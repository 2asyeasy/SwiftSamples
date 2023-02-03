//
//  MarkerInfoView.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 19..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit

protocol MarkerInfoViewDelegate {
    func researchButtonPressed(_ uuid: String)
}

class MarkerInfoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var researchButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var delegate: MarkerInfoViewDelegate?
    var model: SurveyItemModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("MarkerInfoView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        researchButton.setImage(UIImage(named: NSLocalizedString("IMG_BTN_RESEARCH", comment: "")), for: UIControl.State.normal)
    }
        
    public func setData(_ name: String, _ address: String, _ distance: String) {
        nameLabel.text = name
        addressLabel.text = address
        distanceLabel.text = distance
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 101 {
            if delegate != nil {
                delegate?.researchButtonPressed(model.uuid)
            }
        }
    }
}

