//
//  NCameraUtil.swift
//  SmartEnquete
//
//  Created by Khai on 2018. 9. 17..
//  Copyright © 2018년 NUbiz. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class NCameraUtil: NSObject {
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    
    override init() {
        super.init()
        
        initialize()
    }
    
    func initialize() {
        captureSession = AVCaptureSession.init()
    }
    
    func addVideoPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    }
    
    func addVideoInput() {
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if videoDevice != nil {
            let videoIn = try? AVCaptureDeviceInput.init(device: videoDevice!)
            if captureSession.canAddInput(videoIn!) {
                captureSession.addInput(videoIn!)
            }
        }
    }
    
    func setPortrait() {
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        let layerRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        screenLayer(layerRect)
    }
    
    func setLandscapeLeft() {
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        let layerRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        screenLayer(layerRect)
    }
    
    func setLandscapeRight() {
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        let layerRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        screenLayer(layerRect)
    }
    
    func screenLayer(_ layerRect: CGRect) {
        previewLayer.bounds = layerRect
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.position = CGPoint(x: layerRect.midX, y: layerRect.midY)
    }
    
}
