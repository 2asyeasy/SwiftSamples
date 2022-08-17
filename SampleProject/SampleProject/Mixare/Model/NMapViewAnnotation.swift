//
//  MapViewAnnotation.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NMapViewAnnotation: NSObject {

    var coordinate: CLLocationCoordinate2D!
    
    override init() {
        super.init()
    }

    init(_ latitude: Double, _ longitude: Double) {
        if latitude != 0.0 && longitude != 0.0 {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        }
        else {
            coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
        }
        
        super.init()
    }
    
}
