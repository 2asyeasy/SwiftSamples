//
//  MarkerView.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 14..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import UIKit

protocol MarkerViewDelegate {
    func infoWindowPressed(_ uuid: String)
}

class MarkerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var infoBoxImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var progressImageView: UIImageView!
    @IBOutlet var infoWindowButton: UIButton!
    
    var delegate: MarkerViewDelegate?
    var surveyModel: SurveyItemModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    
    private func initialize() {
        backgroundColor = .clear
        
        contentView = loadViewFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width * appDelegate.displayRatio.width, height: contentView.frame.height * appDelegate.displayRatio.height)
        frame = contentView.frame
        addSubview(contentView)
        
        infoBoxImageView.image = UIImage(named: NSLocalizedString("IMG_INFOBOX", comment: ""))
    }
    
    func initialize(_ name: String, _ phone: String, _ distance: String, _ isCompledted: Bool) {
        nameLabel.text = name
        phoneLabel.text = phone
        distanceLabel.text = distance
        progressImageView.image = isCompledted ? UIImage(named: NSLocalizedString("IMG_ICON_COMPLETE", comment: ""))! : UIImage(named: NSLocalizedString("IMG_ICON_ONGOING", comment: ""))!
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.layoutAttachAll(to: self)
        return nibView
    }
    
    @IBAction func infoWindowPressed(_ sender: UIButton) {
        if delegate != nil {
            delegate?.infoWindowPressed(surveyModel.uuid)
        }
    }
    
}

extension MarkerView {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}
