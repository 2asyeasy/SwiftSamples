//
//  NMarkerView.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 18..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit

protocol NMarkerViewDelegate {
    func markerPressed(_ marker: NMarkerModel)
}

class NMarkerView: PassThroughView {

    var imageView: UIImageView!
//    var infowindowView: MarkerView!
    var model: NMarkerModel!
    var delegate: NMarkerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil {
            delegate?.markerPressed(model)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func removeFromSuperview() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

}
