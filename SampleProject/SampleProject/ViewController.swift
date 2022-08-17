//
//  ViewController.swift
//  SampleProject
//
//  Created by Khai on 2020/05/25.
//  Copyright © 2020 NUBiz Inc. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    //  카메라 및 갤러리
    //  info.plist에 권한을 추가할 것 ( 카메라 사용, 갤러리 사용 )
    let picker = UIImagePickerController()
    var cameraMode: ImageFrom  = .camera
    enum ImageFrom {
        case camera
        case gallery
    }
    
    var menus: Array<String> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
        
        initViews()
    }
    
    func initData() -> Void {
        menus.append("PageContent")
        menus.append("Mosaic")
        menus.append("Speech Recognizer")
        menus.append("AVPlayer")
//        menus.append("Mixare")
    }
    
    func initViews() -> Void {
        initTableView()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView() -> Void {
        tableView.register(UINib(nibName: "BaseTableViewCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "menuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseTableViewCell
        cell.titleLabel.text = menus[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                openPageContentViewController()
            }
            else if indexPath.row == 1 {
                showPhotoSelectionAlert()
            }
            else if indexPath.row == 2 {
                openSpeechViewController()
            }
            else if indexPath.row == 3 {
                openAVPlayerViewController()
            }
            else if indexPath.row == 4 {
//                openMixareViewController()
            }
        }
    }
    
    func openPageContentViewController() -> Void {
        //  PageContentViewController 사용 예
        var pageImages: Array<String> = Array()
        pageImages.append("https://i.pinimg.com/originals/22/db/e5/22dbe57eaab70823fddd01579f998874.jpg")
        pageImages.append("https://file3.instiz.net/data/cached_img/upload/2018/08/22/20/5fc425707c33d2636076ea83db1cc031.jpg")
        pageImages.append("https://optimal.inven.co.kr/upload/2019/07/18/bbs/i15768447011.gif")
        
        let viewController = PageMainViewController(nibName: "PageMainViewController", bundle: nil)
        viewController.pageImages = pageImages
        viewController.chosenIndex = 0
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func openMosaicViewController(imageURL: String) -> Void {
        //  MosaicViewController 사용 예
        let viewController = MosaicViewController(nibName: "MosaicViewController", bundle: nil)
        viewController.imageURL = imageURL//"https://i.pinimg.com/originals/22/db/e5/22dbe57eaab70823fddd01579f998874.jpg"
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openSpeechViewController() -> Void {
        let viewController = SpeechViewController(nibName: "SpeechViewController", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openAVPlayerViewController() -> Void {
        let viewController = AVPlayerVC(nibName: "AVPlayerVC", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openMixareViewController() -> Void {
//        let viewController = MixareVC(nibName: "MixareVC", bundle: nil)
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPhotoSelectionAlert() {
        let alertViewController = UIAlertController(title: "알림", message: "사진을 추가합니다.", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCameraView()
        }
        let libraryAction = UIAlertAction(title: "앨범", style: .default) { (action) in
            self.openPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default) { (action) in
            
        }
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(libraryAction)
        alertViewController.addAction(cancelAction)
        self.navigationController?.present(alertViewController, animated: true, completion: {
            
        })
    }
    
    func openCameraView() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .camera
//            picker.cameraCaptureMode = .photo
            picker.mediaTypes = [kUTTypeImage as String]
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }
        else {
            self.showNoCameraAlertDialog()
        }
    }
    
    func showNoCameraAlertDialog() {
        let ac = UIAlertController(title: "경고", message: "이 장비는 카메라를 지원하지 않습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    func openPhotoLibrary() {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        var dateString = ""
        if let year = components.year
            , let month = components.month
            , let day = components.day
            , let hour = components.hour
            , let minute = components.minute
            , let seconds = components.second {
            dateString = String.init(format: "%04d-%02d-%02d-%02d-%02d-%02d", year, month, day, hour, minute, seconds)
        }
        
        var imageURL: String = "thumbnail-\(dateString).png"
        
        let info = Dictionary(uniqueKeysWithValues: info.map {key, value in (key.rawValue, value)})
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            if image.writeImage(filename: imageURL) {
                
            }
            else {
                if let url: URL = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL {
                    imageURL = url.absoluteString
                }
            }
        }
        else {
            if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                if image.writeImage(filename: imageURL) {
                    
                }
                else {
                    if let url: URL = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL {
                        imageURL = url.absoluteString
                    }
                }
            }
        }
        
        self.dismiss(animated: true) {
            self.openMosaicViewController(imageURL: imageURL)
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            
        }
    }
    
    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error as Any)
        }
    }
    
}
