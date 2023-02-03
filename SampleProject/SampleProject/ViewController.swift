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
import Combine

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
    
    private func handleNumber(num: Int?) throws -> Int {
        guard let num = num else { throw CustomError.doNotCast }
        return num * 2
    }
    
    enum CustomError: Error {
        case doNotCast
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
        
        initViews()
        
//        let publisher = [1,2,nil,3,4].publisher
//        let cancellable = publisher
//            .map { $0 * 2 }
//            .sink { print(">>> \($0)") }
//
//        let cancellable = publisher
//            .tryMap {
//                try self.handleNumber(num: $0)
//            }
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print(">>> finished")
//                    break
//                case .failure(let error):
//                    print(">>> error : \(error.localizedDescription)")
//                    break
//                }
//            } receiveValue: { value in
//                print(">>> value : \(value)")
//            }


//        let publisher = ["ABC", "BCD", "CDE"].publisher
//            .delay(for: 1, scheduler: DispatchQueue.main)
//            .map {
//                return ($0, Int.random(in: 0...99))
//            }
//            .print(">>> Random")
//            .share()
////            .multicast {
////                PassthroughSubject<(String, Int), Never>()
////            }
//        let cancellable1 = publisher.sink { output in
//            print(">>> stream 1 : \(output.0), \(output.1)")
//        }
//        let cancellable2 = publisher.sink { output in
//            print(">>> stream 2 : \(output.0), \(output.1)")
//        }
        
//        publisher.connect()
        
        
        
//        let publisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
//        let cancellable = publisher.sink { value in
//            print(">>> \(value)")
//        }
//        publisher.sink { output in
//            print(">>> \(output)")
//        }
        
//        let subject = PassthroughSubject<String, Error>()
//        let subscriber = subject.handleEvents(receiveSubscription: { subscription in
//            print(">>> subscription")
//        }, receiveOutput: { output in
//            print(">>> output")
//        }, receiveCompletion: { completion in
//            print(">>> completion")
//        }, receiveCancel: {
//            print(">>> cancel")
//        }, receiveRequest: { request in
//            print(">>> request")
//        }).sink { completion in
//            switch completion {
//            case .finished:
//                print(">>> finished")
//                break
//            case .failure(let error):
//                print(">>> error : \(error)")
//                break
//            }
//            print(">>> completion")
//        } receiveValue: { value in
//            print(">>> value : \(value)")
//        }
//
//        subject.send("Test")
//        subscriber.cancel()
        
//        let subject = PassthroughSubject<String, Never>()
//        let subscriber = TestSubscriber()
//        subject.print().subscribe(subscriber)
//        subscriber.subscription = CustomSubscription({
//            print(">>> cancelled")
//        })
//
//        subject.send("Khai")
//        subject.send("Khai")
//
//        subscriber.subscription?.cancel()
        
//        let publisher = ["Zedd"].publisher
//        publisher
//            .map { _ in print(Thread.isMainThread) }
//            .receive(on: DispatchQueue.global())
//            .map { _ in print(Thread.isMainThread) }
//            .sink { _ in print(Thread.isMainThread) }
        
//        let publisher = CurrentValueSubject<String, Never>("Zedd")
//
//        publisher
//            .subscribe(on: DispatchQueue.global())
//            .sink { _ in print(">>> sink : \(Thread.isMainThread)") }
        
        
        
//        enum CustomError: Error {
//            case unknown
//        }
//
//        let passthroughSubject = PassthroughSubject<String, Error>()
//        let subscriber = passthroughSubject.sink { completion in
//            switch completion {
//            case .finished:
//                print(">>> finished")
//                break
//            case .failure(let error):
//                print(">>> \(error.localizedDescription)")
//                break
//            }
//        } receiveValue: { value in
//            print(">>> value : \(value)")
//        }
//
//        passthroughSubject.send("Hi")
//        passthroughSubject.send("Zedd")
//
//        passthroughSubject.send(completion: .failure(CustomError.unknown))
//        passthroughSubject.send(completion: .finished)
//        passthroughSubject.send(">>> New")

        
//        let passthroughSubject = PassthroughSubject<String, Never>()
//        let subscriber = passthroughSubject.sink { result in
//            print(">>> \(result)")
//        }
//        passthroughSubject.send("Hi")
//        passthroughSubject.send("Zedd")
        
//        let currentValueSubject = CurrentValueSubject<String, Never>("Zedd")
//        let subscriber = currentValueSubject.sink { value in
//            print(">>> \(value)")
//        }
//        currentValueSubject.value = "Hi"
//        currentValueSubject.send("Hi")
        
//        let publisher = ["Khai", "Sive", "Root", "Admin", "Master"].publisher
//        publisher.print().subscribe(TestSubscriber())
        
//        let subject = PassthroughSubject<String, Never>()
//        let subscriber = TestSubscriber()
//        subject.print().subscribe(subscriber)
//
//        subject.send("Khai")
//        subject.send("Sive")
//        subject.send("Root")
//        subject.send("Admin")
//        subject.send("Master")
//
//        subject.send(completion: .finished)
//
//        subscriber.subscription?.request(.max(2))
//
//        subject.send("Avicii")
//        subject.send("LANY")
//        subject.send("Cash Cash")
        
//        ["test1", "test2", "test3"].publisher.sink { value in
//            print(">>> \(value)")
//        }

        
//        let pubilsher = Just("test")
//        let subscriber = pubilsher.sink { value in
//            print(">>> \(value)")
//        }
//
//        let subsciber = pubilsher.sink { result in
//            switch result {
//            case .finished:
//                print(">>> finished")
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//        } receiveValue: { value in
//            print(">>> \(value)")
//        }
        
//        Task(priority: TaskPriority.background) {
//            await self.process()
//        }
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
    
    func getData() async throws -> Data {
        let url = URL(string: "http://www.witches.kr/")!
        
        //  Synchronous URL loading...
        //let data = try Data(contentsOf: url)
        //  Asynchronous URL loading
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func decode(data: Data) async throws -> String {
        let contents = String(data: data, encoding: String.Encoding.utf8)!
        return contents
    }
    
    func process() async {
        do {
            let data = try await self.getData()
            let contents = try await self.decode(data: data)
            print(contents)
        }
        catch {
            print(error)
        }
    }

}

final class CustomSubscription: Subscription {
    
    private let cancellable: Cancellable
    
    init(_ cancel: @escaping () -> Void) {
        self.cancellable = AnyCancellable(cancel)
    }
    
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        self.cancellable.cancel()
    }
}

class TestSubscriber: Subscriber {
    
    typealias Input = String
    typealias Failure = Never
    
    var subscription: Subscription?

    func receive(subscription: Subscription) {
        //subscription.request(.unlimited)
        subscription.request(.max(1))
        self.subscription = subscription
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        switch input {
        case "Khai":
            return .max(2)
        default:
            return .none
        }
//        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {

    }
}

struct ItemLoader {
    var session = URLSession.shared
    
//    func loadItems(from url: URL) async throws -> [Item] {
//        let (data, _) = try await session.data(from: url)
//        let decoder = JSONDecoder()
//        return try decoder.decode([Item].self, from: data)
//    }
}

struct FileLoader {
    var session = URLSession.shared
    
//    func downloadFile(from url: URL) async throws -> File {
//        let (localUrl, _) = try await session.download(from: url)
//        return File(url: localUrl)
//    }
}

struct FileUploader {
    var session = URLSession.shared

//    func upload(_ data: Data, to url: URL) async throws -> URLResponse {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let (resposneData, response) = try await session.upload(for: request, from: data)
//
//        return response
//    }
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
