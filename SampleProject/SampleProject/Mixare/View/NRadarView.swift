//
//  NRadarView.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit

class NRadarView: UIView {

    let RADIUS_RADAR_VIEW: Double = 30.0
    
    var range: Double = 0.0
    var radius: Double = 5.0
    var markerModels: Array<NMarkerModel> = Array<NMarkerModel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let contextRef: CGContext = UIGraphicsGetCurrentContext()!
        contextRef.setFillColor(red: 0.0, green: 0.0, blue: 115.0, alpha: 0.3)
        contextRef.setStrokeColor(red: 0.0, green: 0.0, blue: 125.0, alpha: 0.1)
        
        contextRef.fillEllipse(in: CGRect(x: 0.5, y: 0.5, width: RADIUS_RADAR_VIEW * 2, height: RADIUS_RADAR_VIEW * 2))
        contextRef.setStrokeColor(red: 0.0, green: 255.0, blue: 0.0, alpha: 0.5)
        
        range = radius * 1000
        let scale = range / RADIUS_RADAR_VIEW
        for i in 0..<markerModels.count {
            var x: Double = 0.0
            var y: Double = 0.0
            
            let model = markerModels[i].locationModel!
            
            if model.azimuth >= 0 && model.azimuth < Double.pi / 2 {
                let cosfValue = Double(cosf((Float.pi / 2) - Float(model.azimuth)))
                let sinfValue = Double(sinf((Float.pi / 2) - Float(model.azimuth)))
                
                x = RADIUS_RADAR_VIEW + cosfValue * (model.radialDistance / scale)
                y = RADIUS_RADAR_VIEW + sinfValue * (model.radialDistance / scale)
            }
            else if model.azimuth > Double.pi / 2 && model.azimuth < Double.pi {
                let cosfValue = Double(cosf(Float(model.azimuth) - (Float.pi / 2)))
                let sinfValue = Double(sinf(Float(model.azimuth) - (Float.pi / 2)))

                x = RADIUS_RADAR_VIEW + cosfValue * (model.radialDistance / scale)
                y = RADIUS_RADAR_VIEW + sinfValue * (model.radialDistance / scale)
            }
            else if model.azimuth > Double.pi && model.azimuth < (3 * Double.pi / 2) {
                let cosfValue = Double(cosf(Float(3 * Double.pi / 2) - Float(model.azimuth)))
                let sinfValue = Double(sinf(Float(3 * Double.pi / 2) - Float(model.azimuth)))

                x = RADIUS_RADAR_VIEW - cosfValue * (model.radialDistance / scale)
                y = RADIUS_RADAR_VIEW - sinfValue * (model.radialDistance / scale)
            }
            else if model.azimuth > (3 * Double.pi / 2) && model.azimuth < (2 * Double.pi) {
                let cosfValue = Double(cosf(Float(model.azimuth) - Float(3 * Double.pi / 2)))
                let sinfValue = Double(sinf(Float(model.azimuth) - Float(3 * Double.pi / 2)))

                x = RADIUS_RADAR_VIEW - cosfValue * (model.radialDistance / scale)
                y = RADIUS_RADAR_VIEW - sinfValue * (model.radialDistance / scale)
            }
            else if model.azimuth == 0 {
                x = RADIUS_RADAR_VIEW
                y = RADIUS_RADAR_VIEW - model.radialDistance / scale
            }
            else if model.azimuth == Double.pi / 2 {
                x = RADIUS_RADAR_VIEW + model.radialDistance / scale
                y = RADIUS_RADAR_VIEW
            }
            else if model.azimuth == (3 * Double.pi / 2) {
                x = RADIUS_RADAR_VIEW
                y = RADIUS_RADAR_VIEW + model.radialDistance / scale
            }
            else if model.azimuth == (3 * Double.pi / 2) {
                x = RADIUS_RADAR_VIEW - model.radialDistance / scale
                y = RADIUS_RADAR_VIEW
            }

            contextRef.setFillColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            if x < RADIUS_RADAR_VIEW * 2 && x > 0 && y > 0 && y < RADIUS_RADAR_VIEW * 2 {
                contextRef.fillEllipse(in: CGRect(x: x, y: y, width: 2.0, height: 2.0))
            }
        }
    }
    
}
