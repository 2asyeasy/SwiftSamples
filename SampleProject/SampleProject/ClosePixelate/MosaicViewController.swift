//
//  MosaicViewController.swift
//  SampleProject
//
//  Created by Khai on 2020/05/26.
//  Copyright © 2020 NUBiz Inc. All rights reserved.
//

import UIKit
import Photos

class MosaicViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mosaicImageView: UIImageView!
    @IBOutlet var mosaicButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var writeButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var restoreButton: UIButton!
    
    var imageURL: String = ""
    var originImage: UIImage? = nil
            
    let mosaicImage: UIImage = UIImage(named: "img_mosaic.png")!.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15), resizingMode: .stretch)
    
    var isMosaic: Bool = false
    var isAddMosaic: Bool = false
    
    //  MARK: - ImageGesture
    var touchRadius: CGFloat = 48.0
    let minRadius: CGFloat = 48.0
    
    enum DragType {
        case DRAG_OFF
        case DRAG_ON
        case DRAG_CENTER
        case DRAG_TOP
        case DRAG_BOTTOM
        case DRAG_LEFT
        case DRAG_RIGHT
        case DRAG_TOPLEFT
        case DRAG_TOPRIGHT
        case DRAG_BOTTOMLEFT
        case DRAG_BOTTOMRIGHT
    }
    
    var currentDragType: DragType = .DRAG_OFF
    var initialFrame: CGRect = CGRect.zero
    var initialTransform: CGAffineTransform = .identity
    var scaleIt: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()    
    }
            
    @IBAction func onButtonPressed(_ sender: UIButton) {
        if sender.tag == 101 {
            doFinish()
        }
        else if sender.tag == 102 {
            showMosaicView(isEnable: !isMosaic)
        }
        else if sender.tag == 103 {
            showDismissAlert()
        }
        else if sender.tag == 111 {
            restoreImage()
        }
        else if sender.tag == 112 {
            setMosaic()
        }
    }

}

extension MosaicViewController {
    
    private func initialize() {
        if let image = UIImage.readImage(filename: imageURL) {
            imageView.image = image
            originImage = image
        }
        
        touchRadius = 48.0
        centerImageView(imageView: mosaicImageView)
                        
        mosaicImageView.contentMode = .scaleToFill
        mosaicImageView.isUserInteractionEnabled = true
        mosaicImageView.isMultipleTouchEnabled = true
        mosaicImageView.layer.borderWidth = 1.0
        mosaicImageView.layer.borderColor = UIColor.white.cgColor
        mosaicImageView.image = mosaicImage
                
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(recognizer:)))
        mosaicImageView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        showMosaicView(isEnable: false)
    }
        
    private func showMosaicView(isEnable: Bool) {
        isMosaic = isEnable
        mosaicButton.isSelected = isMosaic
        
        mosaicImageView.isHidden = !isMosaic
        applyButton.isHidden = !isMosaic
        restoreButton.isHidden = !isMosaic
        
        setButtonPosition(frame: mosaicImageView.frame)
    }
    
    private func doFinish() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showDismissAlert() {
        if isAddMosaic {
            let ac = UIAlertController(title: "알림", message: "모자이크가 적용된 이미지를 저장하시겠습니까?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "저장 후 종료", style: .default) { (action) in
                self.doWrite()
            }
            let no = UIAlertAction(title: "종료", style: .destructive) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            ac.addAction(no)
            ac.addAction(yes)
            self.navigationController?.present(ac, animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    //  MARK: - 이미지 초기화
    private func restoreImage() {
        if let image = originImage {
            self.imageView.image = image
            isAddMosaic = false
        }
    }
    
    private func setButtonPosition(frame: CGRect) {
        restoreButton.center = CGPoint(x: frame.origin.x - (restoreButton.frame.size.width / 4), y: frame.origin.y - (restoreButton.frame.size.height / 4))
        applyButton.center = CGPoint(x: frame.origin.x + frame.size.width + (applyButton.frame.size.width / 4), y: frame.origin.y - (applyButton.frame.size.height / 4))
    }
    
    //  MARK: - 모자이크 적용
    private func setMosaic() {
        if let image = imageView.image
            , let cgimage = image.cgImage {
            let frame = CGRect(x: self.mosaicImageView.frame.origin.x + 15.0, y: self.mosaicImageView.frame.origin.y + 15.0, width: self.mosaicImageView.frame.size.width - 30.0, height: self.mosaicImageView.frame.size.height - 30.0)
            if let cropped = cgimage.cropping(to: frame) {
                if let pixelated = Pixelate.create(pixels: cropped, layers: [PixelateLayer(.square, resolution: 10, alpha: 0.9)]) {
                    let pixelImage: UIImage = UIImage(cgImage: pixelated)
                    if let result: UIImage = drawImage(original: image, oFrame: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), new: pixelImage, nFrame: frame) {
                        self.imageView.image = result
                        UIView.animate(withDuration: 0.1) {
                            self.isAddMosaic = true
                            self.imageView.setNeedsDisplay()
                        }
                    }
                }
            }
        }
    }
    
    private func drawImage(original: UIImage, oFrame: CGRect, new: UIImage, nFrame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(oFrame.size, true, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsPushContext(context)
        }
//        UIGraphicsBeginImageContext(CGSize(width: oFrame.size.width, height: oFrame.size.height))
        original.draw(in: oFrame)
        new.draw(in: nFrame)
        UIGraphicsPopContext()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    //  MARK: - 파일 저장
    private func doWrite() {
        if let image = imageView.image {
            //  MARK: - https://stackoverflow.com/a/35985204
            if PHPhotoLibrary.authorizationStatus() == .authorized {
                
                var localId: String?
                let imageManager = PHPhotoLibrary.shared()
                imageManager.performChanges({
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    localId = request.placeholderForCreatedAsset?.localIdentifier
                }) { (success, error) in
                    if error != nil {
                        print(error as Any)
                    }
                    else {
                        DispatchQueue.main.async {
                            if let localId = localId {
                                let result = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil)
                                if let range = Range(NSRange(location: 0, length: result.count)) {
                                    let assets: [PHAsset] = result.objects(at: IndexSet(integersIn: range))
                                    for item in assets {
                                        item.getURL { (url) in
                                            print(">>> saved image's url : \(url?.absoluteString ?? "nil")")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension MosaicViewController: UIGestureRecognizerDelegate {
    
    //  MARK: - 이미지뷰 센터에 적용
    private func centerImageView(imageView: UIImageView) -> Void {
        let boundsSize = self.view.bounds.size
        var frameToCenter = imageView.frame;
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    //  MARK: - 뷰의 실사이즈 반환
    private func getActualSize(view: UIView) -> CGSize {
        var result: CGSize = CGSize.zero
        
        let originalTransform: CGAffineTransform = view.transform
        let rotation: CGFloat = CGFloat(atan2f(Float(view.transform.b), Float(view.transform.a)))
        let unrotated: CGAffineTransform = view.transform.rotated(by: -rotation)
        
        view.transform = unrotated
        result = view.frame.size
        view.transform = originalTransform
        
        return result
    }
        
    //  MARK: - 드래그 타입
    private func setDragType(frame: CGRect, touch: CGPoint) {
        if frame.size.width > frame.size.height {
            touchRadius = frame.size.width / 3
        }
        else {
            touchRadius = frame.size.height / 3
        }
        
        let bottomRight: CGRect = CGRect(x: frame.origin.x + frame.size.width - touchRadius, y: frame.origin.y + frame.size.height - touchRadius, width: touchRadius * 2, height: touchRadius * 2)
        
        if bottomRight.contains(touch) {
            currentDragType = DragType.DRAG_BOTTOMRIGHT
        }
        else {
            currentDragType = DragType.DRAG_CENTER
        }
        
        if touchRadius < minRadius {
            currentDragType = DragType.DRAG_BOTTOMRIGHT
            touchRadius = minRadius
        }
    }
    
    @objc
    private func handleResize(recognizer: UIPanGestureRecognizer) {
        let touch = recognizer.location(in: self.view)
        let translation = recognizer.translation(in: recognizer.view)
        
        if recognizer.state == .began {
            if let view = recognizer.view {
                initialFrame = view.frame
                initialTransform = view.transform
            }
            else {
                initialFrame = self.mosaicImageView.frame
                initialTransform = self.mosaicImageView.transform
            }
            setDragType(frame: initialFrame, touch: touch)
            scaleIt = true
        }
        else if recognizer.state == .ended {
            currentDragType = .DRAG_OFF
            scaleIt = false
            
            let _ = getActualSize(view: recognizer.view ?? UIView.init())
        }
        else {
            var newFrame = initialFrame
            var tx = translation.x
            var ty = translation.y
                        
            if currentDragType == .DRAG_BOTTOMRIGHT {
                newFrame.size.width += tx
                newFrame.size.height += ty
                
                if newFrame.width < minRadius {
                    newFrame.size.width = minRadius
                }
                if newFrame.height < minRadius {
                    newFrame.size.height = minRadius
                }
                if newFrame.origin.x + newFrame.width > imageView.frame.size.width {
                    newFrame.size.width = imageView.frame.size.width - newFrame.origin.x
                }
                if newFrame.origin.y + newFrame.height > imageView.frame.size.height {
                    newFrame.size.height = imageView.frame.size.height - newFrame.origin.y
                }
                
                if scaleIt {
                    recognizer.view?.frame = newFrame
                }
            }
            else {
                newFrame.origin.x += tx
                newFrame.origin.y += ty
                scaleIt = false
                
                if (newFrame.origin.x < 0) {
                    newFrame.origin.x = 0
                    tx = 0
                }
                if (newFrame.origin.y < 0) {
                    newFrame.origin.y = 0
                    ty = 0
                }
                if newFrame.origin.x + newFrame.width > imageView.frame.size.width {
                    newFrame.origin.x = imageView.frame.size.width - newFrame.width
                }
                if newFrame.origin.y + newFrame.height > imageView.frame.size.height {
                    newFrame.origin.y = imageView.frame.size.height - newFrame.height
                }

                if tx != 0 || ty != 0 {
                    recognizer.view?.frame = newFrame
                }
            }
            
            setButtonPosition(frame: newFrame)
        }
    }
    
    //  MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}

extension PHAsset {

    //  MARK: - https://stackoverflow.com/a/44630089
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
}
