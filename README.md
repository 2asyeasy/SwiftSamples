# SampleProjects <자주 사용하는 커스텀뷰 모음>

## 1. PageContentViewController

  참고 사이트 : https://g-y-e-o-m.tistory.com/119  

  - CustomViewPager 폴더 추가
  
  - CocoaPods 추가
  
    pod 'SDWebImage'  
    pod 'SDWebImage/GIF'  
      
  - info.plist 권한 추가
    
    NSPhotoLibraryAddUsageDescription  
    
  - 사용 예 (Swift 5)
  
    var pageImages: Array<String> = Array()
    pageImages.append("https://i.pinimg.com/originals/22/db/e5/22dbe57eaab70823fddd01579f998874.jpg")             
    pageImages.append("https://file3.instiz.net/data/cached_img/upload/2018/08/22/20/5fc425707c33d2636076ea83db1cc031.jpg")  
    pageImages.append("https://optimal.inven.co.kr/upload/2019/07/18/bbs/i15768447011.gif")
    
    let viewController = PageMainViewController(nibName: "PageMainViewController", bundle: nil)  
    viewController.pageImages = pageImages  
    viewController.chosenIndex = 0   
    self.navigationController?.present(viewController, animated: true, completion: nil)
    
<p align="center"><kbd><img src="https://user-images.githubusercontent.com/39609153/82796025-d77d4d00-9eaf-11ea-8b69-c7341aa8a8d4.png" width="25%" height="25%"></kbd></p>

## 2. MosaicViewController 

  참고 사이트 : https://github.com/bmaslakov/cocoa-close-pixelate

  - Mosaic 폴더 추가

  - info.plist 권한 추가
    
    NSPhotoLibraryAddUsageDescription  

  - 사용 예 (Swift 5)
  
    let viewController = MosaicViewController(nibName: "MosaicViewController", bundle: nil)  
    viewController.imageURL = "https://i.pinimg.com/originals/22/db/e5/22dbe57eaab70823fddd01579f998874.jpg"  
    viewController.modalPresentationStyle = .fullScreen  
    self.navigationController?.present(viewController, animated: true, completion: nil)
    
<p align="center"><kbd><img src="https://user-images.githubusercontent.com/39609153/82852076-c75f7f00-9f3c-11ea-85f9-d16b80d774a6.png" width="25%" height="25%"></kbd></p>

## 3. 음성인식  

  - Speech 폴더 추가
  
  - info.plist 권한 추가
  
    NSMicrophoneUsageDescription
    NSSpeechRecognitionUsageDescription
    
  - 사용 예 (Swift 5)
  
    let viewController = SpeechViewController(nibName: "SpeechViewController", bundle: nil)  
    self.navigationController?.pushViewController(viewController, animated: true)
    
<p align="center"><kbd><img src="https://user-images.githubusercontent.com/39609153/82965045-04da1000-a002-11ea-8c98-4349b750f420.png" width="25%" height="25%"></kbd></p>

## 4. AR
