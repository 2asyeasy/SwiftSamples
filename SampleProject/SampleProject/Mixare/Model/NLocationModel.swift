//
//  LocationModel.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import Foundation
import MapKit

class NLocationModel: NSObject {
    
    var radialDistance: Double = 0.0
    var inclination: Double = 0.0
    var azimuth: Double = 0.0

    var markerLocation: CLLocation!
    
    override init() {
        super.init()
    }
    
    init(_ location: CLLocation) {
        markerLocation = location
    }

    func setAngleData(_ newRadialDistance: Double, _ newInclination: Double, _ newAzimuth: Double) {
        radialDistance = newRadialDistance
        inclination = newInclination
        azimuth = newAzimuth
    }
    
    //  Get Angle From Coordinate
    func angleFromCoordinate(_ firstCoordinate: CLLocationCoordinate2D, _ secondCoordinate: CLLocationCoordinate2D) -> Double {
        let differenceLongitude = secondCoordinate.longitude - firstCoordinate.longitude
        let differenceLatitude = secondCoordinate.latitude - firstCoordinate.latitude
        let possibleAzimuth = (Double.pi * 0.5) - atan(differenceLatitude / differenceLongitude)
        
        if differenceLatitude > 0.0 {
            return possibleAzimuth
        }
        else if differenceLongitude < 0.0 {
            return possibleAzimuth + Double.pi
        }
        else if differenceLatitude < 0.0 {
            return Double.pi
        }
        
        return 0.0
    }
    
    //  Calibrate Using Origin
    func calibrateUsingOrigin(_ originLocation: CLLocation) {
        if markerLocation == nil {
            return
        }
        let baseDistance = originLocation.distance(from: markerLocation)
        radialDistance = sqrt(pow(originLocation.altitude - markerLocation.altitude, 2) + pow(baseDistance, 2))
        var angle = sin(abs(originLocation.altitude - markerLocation.altitude) / radialDistance)
        if originLocation.altitude > markerLocation.altitude {
            angle = angle * -1
        }
        inclination = angle
        azimuth = angleFromCoordinate(originLocation.coordinate, markerLocation.coordinate)
    }
    
    func degreesToRadians(_ origin: Double) -> Double {
        return Double.pi * origin / 180.0
    }
    
    func radiansToDegrees(_ origin: Double) -> Double {
        return origin * (180.0 / Double.pi)
    }
    
    
}
