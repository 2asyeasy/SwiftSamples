//
//  AVPlayerVC.swift
//  SampleProject
//
//  Created by Seonggwan Mun on 2022/07/21.
//  Copyright © 2022 NUBiz Inc. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import AVFoundation

class AVPlayerVC: UIViewController {

    @IBOutlet var contentView: UIView!
    
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
        
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initViews()
    }
    
    func initData() -> Void {
        
    }
    
    func initViews() -> Void {
        let urlString = "https://appdata2.rendev.kr/2021/YangnimSmartTour/video/sample.mp4"
        let url = URL(string: urlString)!
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        view.backgroundColor = UIColor.yellow
        contentView.addSubview(view)
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player?.play()
    }

}
