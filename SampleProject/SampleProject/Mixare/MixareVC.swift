//
//  MixareVC.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 14..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit
import MapKit
import CoreMotion
import CoreLocation
import QuartzCore

class MixareVC: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var markerInfoView: UIView!
    
    let VIEWPORT_WIDTH_RADIANS: Double = 0.5
    let VIEWPORT_HEIGHT_RADIANS: Double = 0.7392
    let kFilteringFactor: Double = 0.05
    let kFilteringFactorX: Double = 0.002
    let INFOWINDOW_WIDTH: Double = 333.0
    let INFOWINDOW_HEIGHT: Double = 150.0

    var nCameraManager = NCameraUtil()
    var locationManager: CLLocationManager = CLLocationManager.init()
    var motionManager: CMMotionManager = CMMotionManager.init()

    var overlayView: PassThroughView!
    var radarView: NRadarView!
    var radarViewPort: NRadarViewPort!
    
    var scaleViewsBasedOnDistance: Bool = false
    var maximumScaleDistance: Double = 0.0
    var minimumScaleFactor: Double = 0.6
    var updateFrequency: Double = 1 / 20
    var rotateViewsBasedOnPerspective: Bool = false
    var maximumRorationAngle: Double = Double.pi / 6.0
    
    var centerLocation: NLocationModel!
    var rollingX: UIAccelerationValue = 0.0
    var rollingZ: UIAccelerationValue = 0.0
    var oldHeading: Int = 0
    var updateTimer: Timer!
    
    var markerArray: Array<NMarkerModel> = Array<NMarkerModel>()
    var markerViewArray: Array<NMarkerView> = Array<NMarkerView>()
    
    var isBack = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isBack {
            removeOverlayView()
            removeCameraController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //  Return Previous View Controller - Map View Controller
        if sender.tag == 101 {
            isBack = true
            stopListening()
            if updateTimer != nil {
                updateTimer.invalidate()
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func initialize() {
        overlayView = nil
//        markerArray.removeAll()
//        markerViewArray.removeAll()
        
        //  Do not set Timer Frequency
        updateTimer = nil
        updateFrequency = 1 / 20.0  //  Default

        //  View
        initializeOverlayView()
        //  Camera
        //#if !(arch(i386) || arch(x86_64)) && os(iOS)
        #if !targetEnvironment(simulator)
        addCameraController()
        #endif
        
        scaleViewsBasedOnDistance = false
        maximumScaleDistance = 0.0
        minimumScaleFactor = 0.6
        rotateViewsBasedOnPerspective = false
        maximumRorationAngle = Double.pi / 6.0
        oldHeading = 0
        
        //  Location Manager & Motion Manager
        startListening()
        
        mapButton.setImage(UIImage(named: NSLocalizedString("IMG_BTN_MAP", comment: "")), for: UIControl.State.normal)
        
        addRadarView()
    }
    
}

extension MixareVC: MarkerInfoViewDelegate {
    //  MARK: - TitleViewDelegate
    func backButtonPressed() {
        isBack = true
        stopListening()
        if updateTimer != nil {
            updateTimer.invalidate()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func researchButtonPressed(_ uuid: String) {
        
    }
    
}

extension MixareVC: NMarkerViewDelegate {
    //  Camera Controller
    func addCameraController() {
        nCameraManager.addVideoInput()
        nCameraManager.addVideoPreviewLayer()
        nCameraManager.setPortrait()
        contentView.layer.addSublayer(nCameraManager.previewLayer)
        nCameraManager.captureSession.startRunning()
    }
    
    func removeCameraController() {
        nCameraManager.previewLayer.removeFromSuperlayer()
        nCameraManager.captureSession.stopRunning()
    }
    
    //  Overlay View
    func initializeOverlayView() {
        if UIDevice.current.orientation == .landscapeLeft {
            overlayView = PassThroughView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        }
        else {
            overlayView = PassThroughView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        }
        overlayView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
    }

    func removeOverlayView() {
        overlayView.removeFromSuperview()
        overlayView = nil
    }
    
    //  Radar View
    func addRadarView() {
        radarView = NRadarView.init(frame: CGRect(x: 2, y: 2, width: 60, height: 60))
        radarView.backgroundColor = .clear
        radarViewPort = NRadarViewPort.init(frame: radarView.frame)
        radarViewPort.backgroundColor = .clear
        
        let northLabel = UILabel.init(frame: CGRect(x: 27, y: 2, width: 10, height: 10))
        northLabel.backgroundColor = .clear
        northLabel.textColor = .white
        northLabel.font = UIFont.systemFont(ofSize: 8.0)
        northLabel.textAlignment = NSTextAlignment.center
        northLabel.text = "N"
        northLabel.alpha = 0.8
        
        overlayView.addSubview(radarView)
        overlayView.addSubview(radarViewPort)
        overlayView.addSubview(northLabel)
        
        contentView.addSubview(overlayView)
        
        
        //  ---------------------------------------------------------
        //  Content View
        //      |
        //  Overlay View
        //      |-----------------|------------------|
        //  Radar View      Marker View     InfoWindow View
        //  ---------------------------------------------------------
    }
        
    func markerPressed(_ marker: NMarkerModel) {
        //  If user select marker, open infowindow & infowindow view
        var tempArray = markerArray
        var isHideenMarkerInfoView: Bool = true
        
        for i in 0..<tempArray.count {
            if tempArray[i] == marker {
                tempArray[i].isSelected = !tempArray[i].isSelected
            }
            else {
                tempArray[i].isSelected = false
            }
            
            if tempArray[i].isSelected {
                isHideenMarkerInfoView = false
            }
        }
        
        addMarkerInfoView(marker.surveyModel, isHideenMarkerInfoView)
        refresh(tempArray)
    }
    
    func addMarkerInfoView(_ model: SurveyItemModel, _ isHidden: Bool) {
        //  Add Marker Infowindow View
        if markerInfoView == nil {
            markerInfoView = MarkerInfoView()
        }
        var distanceString = ""
        
        //  locationManager
//        if let currentLocation = appDelegate.currentLocation,
//            let lat = model.lat,
//            let lng = model.lng {
//            
//            let distance = currentLocation.distance(from: CLLocation.init(latitude: lat, longitude: lng))
//            if distance > 1000 {
//                distanceString = String.init(format: "%.3f km", Float(Int(round(distance))) / 1000)
//            }
//            else {
//                distanceString = String.init(format: "%d m", Int(round(distance)))
//            }
//        }
        
        markerInfoView.setData(model.name!, model.phone, distanceString)
        markerInfoView.frame = CGRect(x: 0, y: 0, width: markerInfoView.frame.width * appDelegate.displayRatio.width, height: markerInfoView.frame.height * appDelegate.displayRatio.height)
        markerInfoView.delegate = self
        markerInfoView.model = model
        markerInfoView.isHidden = isHidden
        self.view.addSubview(markerInfoView)
    }
    
    func hideMarkerInfoView() {
        markerInfoView.removeFromSuperview()
        markerInfoView = nil
    }
    
    func resetMarkers() {
        var tempArray = markerArray
        for i in 0..<tempArray.count {
            tempArray[i].isSelected = false
        }
        
        refresh(tempArray)
        if markerInfoView != nil {
            markerInfoView.isHidden = true
        }
    }
}

extension MixareVC: UIAccelerometerDelegate, CLLocationManagerDelegate {
    //  Location Frequency
    func startTimer() {
        //  Update Timer
        if updateTimer == nil {
            updateTimer = Timer.scheduledTimer(timeInterval: updateFrequency, target: self, selector: #selector(updateLocations(_:)), userInfo: nil, repeats: true)
        }        
    }
    
    func updateFrequency(_ newFrequency: Double) {
        //  Update Timer Frequency
        //  I recommed don't set it.
        //  If you set frequency, check the performance exactly.
        updateFrequency = newFrequency
        if updateTimer == nil {
            return
        }
        updateTimer.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: updateFrequency, target: self, selector: #selector(updateLocations(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateLocations(_ sender: Timer) {
        //  Update Location
        if markerArray.count == 0 || markerViewArray.count == 0 {
            return
        }
        var radarPointValues = Array<NMarkerModel>()
        for i in 0..<markerArray.count {
            let markerView = markerViewArray[i]
            if viewportContainsCoordinate(markerArray[i]) {
                let point = pointInView(overlayView, markerArray[i])
                let width = markerView.bounds.width
                let height = markerView.bounds.height
                markerView.frame = CGRect(x: point.x - width / 2.0, y: point.y - height / 2, width: width, height: height)
                if markerView.superview == nil {
                    overlayView.addSubview(markerView)
                }
            }
            else {
                markerView.removeFromSuperview()
                markerView.transform = CGAffineTransform.identity
            }
            radarPointValues.append(markerArray[i])
        }
        
        radarView.markerModels = radarPointValues
        radarView.radius = 5.0
        radarView.setNeedsDisplay()
    }
    
    func startListening() {
        //  Start Listener - Location, Motion
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        motionManager.accelerometerUpdateInterval = 1.0
        motionManager.gyroUpdateInterval = 1.0
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            self.outputAccerlerationData((data?.acceleration)!)
        }
        
        if centerLocation == nil {
            centerLocation = NLocationModel.init(CLLocation(latitude: 0.0, longitude: 0.0))
            centerLocation.setAngleData(0.0, 0.0, 0.0)
        }
    }
    
    func stopListening() {
        //  Stop Listener in using disappering view controller
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
    
    func outputAccerlerationData(_ acceleration: CMAcceleration) {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor))
            rollingX = (acceleration.x * kFilteringFactorX) + (rollingX * (1.0 - kFilteringFactorX))
        }
        else {
            rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor))
            rollingX = (acceleration.y * kFilteringFactorX) + (rollingX * (1.0 - kFilteringFactorX))
        }
        
        if rollingZ > 0.0 {
            centerLocation.inclination = atan(rollingX / rollingZ) + Double.pi / 2.0
        }
        else if rollingZ < 0.0 {
            centerLocation.inclination = atan(rollingX / rollingZ) - Double.pi / 2.0
        }
        else if rollingX < 0 {
            centerLocation.inclination = Double.pi / 2.0
        }
        else if rollingX >= 0 {
           centerLocation.inclination = 3 * Double.pi / 2.0
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        centerLocation.azimuth = fmod(newHeading.magneticHeading, 360.0) * (2 * (Double.pi / 360.0))
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            if centerLocation.azimuth < (3 * Double.pi / 2) {
                centerLocation.azimuth += (Double.pi / 2)
            }
            else {
                centerLocation.azimuth = fmod(centerLocation.azimuth + (Double.pi / 2), 360.0)
            }
        }
        
        var gradToRotate = newHeading.trueHeading - 90.0 - 22.5
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            gradToRotate += 90
        }
        
        if gradToRotate < 0 {
            gradToRotate = gradToRotate + 360
        }
        radarViewPort.referenceAngle = gradToRotate
        radarViewPort.setNeedsDisplay()
        oldHeading = Int(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
}

extension MixareVC: MarkerViewDelegate {
    
    func changeCenterLocation(_ newLocation: CLLocation) {
        for i in 0..<markerArray.count {
            markerArray[i].locationModel.calibrateUsingOrigin(newLocation)
            if markerArray[i].locationModel.radialDistance > maximumScaleDistance {
                maximumScaleDistance = markerArray[i].locationModel.radialDistance
            }
        }
    }
    
    func refresh(_ models: Array<SurveyItemModel>) {
        removeCoordinates()
        
        for i in 0..<models.count {
            if models[i].lat != nil && models[i].lng != nil {
                let model: NMarkerModel = NMarkerModel.init(models[i])
                addCoordinate(model)
            }
        }
    }
    
    func refresh(_ models: Array<NMarkerModel>) {
        removeCoordinates()
        
        for model in models {
            addCoordinate(model)
        }
    }
    
    func viewForCoordinate(_ model: NMarkerModel) -> NMarkerView {
        //  Core - Painting Marker View
        let tempView = NMarkerView.init(frame: CGRect.zero)
        
        tempView.infowindowView = MarkerView()
        let surveyModel = model.surveyModel!
        
        // 수치 계산 마커 높이와 인포인도위 높이의 비율 : ０.３８２
        var distanceString = ""
        if let location = appDelegate.currentLocation,
            let lat = surveyModel.lat,
            let lng = surveyModel.lng {
            
            let distance = location.distance(from: CLLocation.init(latitude: lat, longitude: lng))
            if distance > 1000 {
                distanceString = String.init(format: "%.3f km", Float(Int(round(distance))) / 1000)
            }
            else {
                distanceString = String.init(format: "%d m", Int(round(distance)))
            }
        }
        
        let isFinished = surveyModel.finishedInvestigatorDate
        tempView.infowindowView.initialize((surveyModel.name)!, (surveyModel.phone)!, distanceString, isFinished != nil ? true : false)
        tempView.infowindowView.frame = CGRect(x: 0, y: 0, width: tempView.infowindowView.frame.width * appDelegate.displayRatio.width, height: tempView.infowindowView.frame.height * appDelegate.displayRatio.height)
        tempView.infowindowView.delegate = self
        tempView.infowindowView.infoWindowButton.tag = surveyModel.rtNo!
        tempView.infowindowView.surveyModel = surveyModel
        tempView.infowindowView.isUserInteractionEnabled = model.isSelected
        
        let tempFrame = CGRect(x: 0, y: 0, width: tempView.infowindowView.frame.width, height: tempView.infowindowView.frame.height + 99)
        tempView.frame = tempFrame
        
        let imageViewFrame = CGRect(x: tempView.infowindowView.frame.width / 2 - 33, y: tempView.infowindowView.frame.height, width: 66, height: 99)
        tempView.imageView = UIImageView.init(image: model.getMarkerImage(model.isSelected))
        tempView.imageView.frame = imageViewFrame
        tempView.imageView.alpha = 0.8
        tempView.imageView.isUserInteractionEnabled = true
        
        tempView.model = model
        tempView.delegate = self
        tempView.addSubview(tempView.infowindowView)
        tempView.addSubview(tempView.imageView)
        tempView.isUserInteractionEnabled = true
        
        tempView.infowindowView.isHidden = !model.isSelected

        return tempView
    }
    
    func viewportContainsCoordinate(_ model: NMarkerModel) -> Bool {
        let centerAzimuth = centerLocation.azimuth
        var leftAzimuth = centerAzimuth - VIEWPORT_WIDTH_RADIANS / 2.0
        if leftAzimuth < 0.0 {
            leftAzimuth = 2 * Double.pi + leftAzimuth
        }
        var rightAzimuth = centerAzimuth + VIEWPORT_WIDTH_RADIANS / 2.0
        if rightAzimuth > 2 * Double.pi {
            rightAzimuth = rightAzimuth - 2 * Double.pi
        }
        var result = model.locationModel.azimuth > leftAzimuth && model.locationModel.azimuth < rightAzimuth
        if leftAzimuth > rightAzimuth {
            result = model.locationModel.azimuth < rightAzimuth || model.locationModel.azimuth > leftAzimuth
        }
        let centerInclination = centerLocation.inclination
        let bottomInclination = centerInclination - VIEWPORT_HEIGHT_RADIANS / 2.0
        let topInclinvation = centerInclination + VIEWPORT_HEIGHT_RADIANS / 2.0
        
        //  Check the height
        result = result && (model.locationModel.inclination > bottomInclination && model.locationModel.inclination < topInclinvation)
        return true
    }
    
    func pointInView(_ realityView: UIView, _ model: NMarkerModel) -> CGPoint {
        var point: CGPoint = CGPoint.zero
        
        let pointAzimuth = model.locationModel.azimuth
        var leftAzimuth = centerLocation.azimuth - VIEWPORT_WIDTH_RADIANS / 2.0
        if leftAzimuth < 0.0 {
            leftAzimuth = 2 * Double.pi + leftAzimuth
        }
        if pointAzimuth < leftAzimuth {
            point.x = CGFloat(((2.0 * Double.pi - leftAzimuth + pointAzimuth) / VIEWPORT_WIDTH_RADIANS) * Double(realityView.frame.width))
        }
        else {
            point.x = CGFloat((Double(pointAzimuth - leftAzimuth) / VIEWPORT_WIDTH_RADIANS) * Double(realityView.frame.width))
        }

        let pointInclination = model.locationModel.inclination
        let topInclination = centerLocation.inclination - VIEWPORT_HEIGHT_RADIANS / 2.0
        point.y = CGFloat(Double(realityView.frame.height) - Double((pointInclination - topInclination) / VIEWPORT_HEIGHT_RADIANS) * Double(realityView.frame.height))
        if point.y < 250.0 {
            point.y = 250.0
        }
        else if point.y > 350 {
            point.y = 350.0
        }
        
        return point
    }
    
    func rotatePointAbountOrigin(_ point: CGPoint, _ angle: Float) -> CGPoint {
        let sinValue = CGFloat(sinf(angle))
        let cosValue = CGFloat(cosf(angle))
        
        return CGPoint(x: cosValue * point.x - sinValue * point.y , y: sinValue * point.x + cosValue * point.y)
    }
    
    func addCoordinate(_ model: NMarkerModel) {
        addCoordinate(model, true)
    }
    
    func addCoordinate(_ model: NMarkerModel, _ animated: Bool) {
        markerArray.append(model)
        
        if model.locationModel.radialDistance > maximumScaleDistance {
            maximumScaleDistance = model.locationModel.radialDistance
        }
        markerViewArray.append(viewForCoordinate(model))
    }
    
    func addCoordinates(_ models: [NMarkerModel]) {
        for i in 0..<models.count {
            addCoordinate(models[i])
        }
    }
    
    func removeCoordinate(_ model: NMarkerModel) {
        removeCoordinate(model, true)
    }
    
    func removeCoordinate(_ model: NMarkerModel, _ animated: Bool) {
        for i in 0..<markerArray.count {
            if markerArray[i] == model {
                markerArray.remove(at: i)
                markerViewArray[i].removeFromSuperview()
                markerViewArray.remove(at: i)
                break
            }
        }
    }
    
    func removeCoordinates() {
        if overlayView != nil {
            for i in 0..<markerViewArray.count {
                markerViewArray[i].removeFromSuperview()
            }
        }
        markerArray.removeAll()
        markerViewArray.removeAll()
    }
    
    func infoWindowPressed(_ uuid: String) {
        appDelegate.currentResearchModel.target = uuid
        let viewController = SurveyViewController(nibName: "SurveyViewController", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension MixareVC {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetMarkers()
    }
}

extension MixareVC {
    //  MARK: - AppDelegate
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}
