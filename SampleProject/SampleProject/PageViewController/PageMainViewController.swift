//
//  PageMainViewController.swift
//  safetyMap
//
//  Created by Khai on 2019/10/24.
//  Copyright © 2019 NUbiz. All rights reserved.
//

import UIKit

class PageMainViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var viewPager: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var downloadButton: UIButton!
    
    public var pageViewController: UIPageViewController!
    public var pageImages: Array<String> = Array()
    var currentIndex: Int = 0
    var chosenIndex: Int = 0
            
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()        
    }

    @IBAction func onButtonPressed(_ sender: UIButton) {
        if sender.tag == 100 {
            self.dismiss(animated: true, completion: nil)            
        }
        else if sender.tag == 101 {
            //  현재 사진을 갤러리에 저장함
            //  권한 필요 : NSPhotoLibraryAddUsageDescription
            downloadImage()
        }
    }
    
}

extension PageMainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private func initialize() {
        pageViewController = PageViewController(nibName: "PageViewController", bundle: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startViewController = self.viewControllerAtIndex(index: chosenIndex) as PageContentViewController
        let viewControllers = NSArray(object: startViewController)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.addChild(self.pageViewController)
        self.viewPager.addSubview(self.pageViewController.view)
        
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.viewPager.addConstraint(NSLayoutConstraint(item: self.pageViewController.view as Any, attribute: .top, relatedBy: .equal, toItem: self.viewPager, attribute: .top, multiplier: 1, constant: 0))
        self.viewPager.addConstraint(NSLayoutConstraint(item: self.pageViewController.view as Any, attribute: .left, relatedBy: .equal, toItem: self.viewPager, attribute: .left, multiplier: 1, constant: 0))
        self.viewPager.addConstraint(NSLayoutConstraint(item: self.pageViewController.view as Any, attribute: .bottom, relatedBy: .equal, toItem: self.viewPager, attribute: .bottom, multiplier: 1, constant: 0))
        self.viewPager.addConstraint(NSLayoutConstraint(item: self.pageViewController.view as Any, attribute: .right, relatedBy: .equal, toItem: self.viewPager, attribute: .right, multiplier: 1, constant: 0))
        
        pageControl.numberOfPages = self.pageImages.count
        pageControl.currentPage = currentIndex

        closeButton.isUserInteractionEnabled = true
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController {
        let viewController = PageContentViewController(nibName: "PageContentViewController", bundle: nil)
        viewController.index = index
        viewController.imageURL = pageImages[index]
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PageContentViewController
        var index = viewController.index as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PageContentViewController
        var index = viewController.index as Int
        
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == self.pageImages.count {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentIndex = self.chosenIndex
            self.pageControl.currentPage = self.currentIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let viewController = pendingViewControllers[0] as! PageContentViewController
        self.chosenIndex = viewController.index
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.chosenIndex
    }
    
    func downloadImage() {
        if currentIndex < 0 {
            return
        }
        if currentIndex > pageImages.count {
            return
        }
        
        if let url = URL(string: pageImages[currentIndex])
            , let data = try? Data(contentsOf: url)
            , let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.showDownloadAlert(isSuccess: true)
        }
        else {
            self.showDownloadAlert(isSuccess: false)
        }
    }
    
    func showDownloadAlert(isSuccess: Bool) {
        let ac = UIAlertController(title: "알림", message: isSuccess ? "다운로드되었습니다." : "다운로드가 실패하였습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
            
        }
        ac.addAction(ok)
        self.present(ac, animated: true, completion: nil)
    }
    
}

extension UIImage {
    
    static func readImage(filename: String) -> UIImage? {
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(filename, isDirectory: false).path)
        }
        
        return nil
    }
    
    func writeImage(filename: String) -> Bool {
        guard let data = self.jpegData(compressionQuality: 1) ?? self.pngData()
            , let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL
        else { return false }
                
        do {
            let dest = directory.appendingPathComponent(filename, isDirectory: false)
            try data.write(to: dest, options: Data.WritingOptions.atomic)
//            try data.write(to: directory.appendingPathComponent(filename, isDirectory: false))
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }

}
