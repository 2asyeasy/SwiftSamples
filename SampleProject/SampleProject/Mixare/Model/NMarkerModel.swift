//
//  MarkerModel.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import Foundation
import MapKit

class NMarkerModel: NSObject {
    
    var surveyModel: SurveyItemModel!
    var mapViewAnnotation: NMapViewAnnotation!
    var locationModel: NLocationModel!
    var isSelected: Bool = false
    
    init(_ model: SurveyItemModel) {
        super.init()
        
        surveyModel = model
        guard let latitude = surveyModel.lat, let longitude = surveyModel.lng else {
            return
        }
        
        mapViewAnnotation = NMapViewAnnotation.init(latitude, longitude)
        let location: CLLocation = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude), altitude: 50.0, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: Date())
        locationModel = NLocationModel.init(location)
    }
    
    func getMarkerImage(_ selected: Bool = false) -> UIImage {
        isSelected = selected
        return imageWithImage(isSelected ? UIImage.init(named: "img_marker_on")! : UIImage.init(named: "img_marker_off")!, newSize: CGSize(width: 69, height: 99))
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
    }
    
    func imageWithImage(_ originImage: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        originImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
        
}
