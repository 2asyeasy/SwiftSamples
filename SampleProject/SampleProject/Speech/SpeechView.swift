//
//  SpeechView.swift
//  SampleProject
//
//  Created by Khai on 2020/05/27.
//  Copyright © 2020 NUBiz Inc. All rights reserved.
//

import UIKit

protocol SpeechViewDelegate {
    
    func startRecoding()
    func stopRecoding()
    func dismissRecoderView()
    
}

class SpeechView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var recodingImageView: UIImageView!
    @IBOutlet var recodingButton: UIButton!
    @IBOutlet var recodingLabel: UILabel!
    
    var delegate: SpeechViewDelegate!
    var isRecoding: Bool = false
    var isAnimate: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("SpeechView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        emptyView.addGestureRecognizer(tapGesture)
        
        recodingImageView.isUserInteractionEnabled = false
    }

    private func showAnimation() {
        if isRecoding {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.isAnimate = !self.isAnimate
                self.recodingButton.setImage(UIImage(named: self.isAnimate ? "btn_speech_on.png" : "btn_speech_off.png"), for: .normal)
                self.showAnimation()
            })
        }
        else {
            DispatchQueue.main.async {
                self.recodingButton.setImage(UIImage(named: "btn_speech_off.png"), for: .normal)
            }
        }
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        if sender.tag == 101 {
            isRecoding = !isRecoding
            if delegate != nil {
                if isRecoding {
                    delegate.startRecoding()
                }
                else {
                    delegate.stopRecoding()
                }
                self.showAnimation()
            }
        }
    }
    
    @objc
    private func dismissView() {
        if delegate != nil {
            delegate.stopRecoding()
            delegate.dismissRecoderView()
        }
    }

}
