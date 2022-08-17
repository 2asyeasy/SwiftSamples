//
//  NRadarViewPort.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit

class NRadarViewPort: UIView {

    let RADIUS_RADAR_VIEWPORT: Double = 30.0
    
    var newAngle: Double = 45.0
    var referenceAngle: Double = 247.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let contextRef: CGContext = UIGraphicsGetCurrentContext()!
        contextRef.setFillColor(red: 0.0, green: 255.0, blue: 115.0, alpha: 0.3)
        contextRef.move(to: CGPoint(x: RADIUS_RADAR_VIEWPORT, y: RADIUS_RADAR_VIEWPORT))
        contextRef.addArc(center: CGPoint(x: RADIUS_RADAR_VIEWPORT, y: RADIUS_RADAR_VIEWPORT), radius: CGFloat(RADIUS_RADAR_VIEWPORT), startAngle: CGFloat(radians(referenceAngle)), endAngle: CGFloat(radians(referenceAngle + newAngle)), clockwise: false)
        contextRef.closePath()
        contextRef.fillPath()
    }
    
    func radians(_ origin: Double) -> Double {
        return (Double.pi * origin) / 180.0
    }
}
