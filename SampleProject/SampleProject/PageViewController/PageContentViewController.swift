//
//  PageContentViewController.swift
//  safetyMap
//
//  Created by Khai on 2019/10/24.
//  Copyright © 2019 NUbiz. All rights reserved.
//

import UIKit
import SDWebImage

class PageContentViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    public var index: Int!
    public var imageURL: String!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView?.alwaysBounceVertical = false
        scrollView?.alwaysBounceHorizontal = false
        scrollView?.minimumZoomScale = 1.0
        scrollView?.maximumZoomScale = 3.0
        scrollView?.delegate = self
 
        //  페이징 할 때마다 새로 이미지를 다운로드 받지 않기 위해서 디스크에 저장함
        if let iv = imageView
            , let urlString = imageURL {
            if let url = URL(string: urlString) {
                let key = SDWebImageManager.shared().cacheKey(for: url)
                if let data = SDWebImageManager.shared().imageCache?.diskImageData(forKey: key) {
                    let nData = NSData(data: data)
                    DispatchQueue.main.async {
                        if nData.imageFormat == .GIF {
                            iv.image = UIImage.sd_animatedGIF(with: Data(referencing: nData))
                        }
                        else {
                            iv.image = UIImage(data: Data(referencing: nData))
                        }
                    }
                }
                else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, completed: { (image, data, error, isFinished) in
                        if error != nil {
                            print(error as Any)
                        }
                        else {
                            if isFinished {
                                SDWebImageManager.shared().imageCache?.storeImageData(toDisk: data, forKey: key)
                            }
                            if data != nil {
                                let nData = NSData(data: data!)
                                DispatchQueue.main.async {
                                    if nData.imageFormat == .GIF {
                                        iv.image = UIImage.sd_animatedGIF(with: Data(referencing: nData))
                                    }
                                    else {
                                        iv.image = UIImage(data: Data(referencing: nData))
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}

struct ImageHeaderData {
    
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
    
}

enum ImageFormat {
    case Unknown, PNG, JPEG, GIF, TIFF
}

extension NSData {
    
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG {
            return .PNG
        } else if buffer == ImageHeaderData.JPEG {
            return .JPEG
        } else if buffer == ImageHeaderData.GIF {
            return .GIF
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02 {
            return .TIFF
        } else {
            return .Unknown
        }
    }
    
}
