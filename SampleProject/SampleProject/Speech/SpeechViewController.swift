//
//  SpeechViewController.swift
//  SampleProject
//
//  Created by Khai on 2020/05/27.
//  Copyright © 2020 NUBiz Inc. All rights reserved.
//

import UIKit
import Speech

class SpeechViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var speechButton: UIButton!
    @IBOutlet var speechTextView: UITextView!
    @IBOutlet var speechTextViewHeightConstraint: NSLayoutConstraint!
    
    var speechView: SpeechView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR")) //  지역설정
    var request: SFSpeechAudioBufferRecognitionRequest!
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initData()
        
        initViews()
    }


    @IBAction func onButtonPressed(_ sender: UIButton) {
        if sender.tag == 101 {
            showSpeechView()
        }
    }
    
    func initData() {
        
    }
    
    func initViews() {
        speechTextView.delegate = self
        speechTextView.text = ""
    }
    
}

extension SpeechViewController: SFSpeechRecognizerDelegate, SpeechViewDelegate {
    
    
    enum SpeechAlertType {
        case permissionDenied
        case functionError
    }
    
    //  MARK: - NSSpeechRecognitionUsageDescription, NSMicrophoneUsageDescription 권한 추가 할 것
    func checkPermission(isAuthorized: @escaping (Bool) -> Void) -> Void {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    isAuthorized(true)
                }
                else {
                    isAuthorized(false)
                }
            }
        }
    }
        
    func showSpeechAlert(alertType: SpeechAlertType) -> Void {
        let message = alertType == .permissionDenied ? "기능을 사용하시려면 권한을 허용해주세요." : "기능을 사용할 수 없습니다."
        let ac = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
            
        }
        ac.addAction(ok)
        self.navigationController?.present(ac, animated: true, completion: nil)
    }

    func showSpeechView() -> Void {
        checkPermission(isAuthorized: { (granted) in
            if granted {
                self.speechView = SpeechView(frame: self.contentView.bounds)
                self.speechView.delegate = self
                self.contentView.addSubview(self.speechView)
            }
            else {
                self.showSpeechAlert(alertType: .permissionDenied)
            }
        })
    }
    
    func startRecoding() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        request = SFSpeechAudioBufferRecognitionRequest()
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        }
        catch {
            print(error.localizedDescription)
        }

        guard let recognizer = SFSpeechRecognizer() else {
            return
        }

        if !recognizer.isAvailable {
            return
        }

        recognitionTask?.finish()
        recognitionTask = nil
        if recognitionTask == nil {
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                if let result = result {
                    let bestString = result.bestTranscription.formattedString
                    self.speechTextView.text = bestString

                    for segment in result.bestTranscription.segments {
                        let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                        //lastString = bestString.substring(from: indexTo)
                        //  MARK: - https://stackoverflow.com/a/46617119
                        let lastString = String(bestString[indexTo...])
                        print(">>> lastString : \(lastString)")
                    }
                }
                else if let error = error {
                    print(">>> task error : \(error.localizedDescription)")
                    //  MARK: - The operation couldn’t be completed. (kAFAssistantErrorDomain error 216.)
                    //  recognitionTask 는 진행중이나 cancel을 수행하려하는 경우 이미 진행중인 업무에서 발생하는 오류
                    //  해결하려면 정해진 시간 단위로 음성인식 진행 및 취소를 반복하면 된다.
                    //  task 및 cancel 함수를 재정의 할 것.
                }
            })
        }
        else {
            stopRecoding()
            startRecoding()
        }
    }
    
    func stopRecoding() {
        //  MARK: - kAFAssistantErrorDomain error 216.
        //  https://stackoverflow.com/a/46294296
        
        if audioEngine.isRunning {
            let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
            node.reset()
            audioEngine.stop()
            request.endAudio()
            if let task = recognitionTask {
                switch task.state {
                case .starting:
                    
                    break
                case .running:
                    task.cancel()

                    break
                case .completed:
                    
                    break
                case .canceling:
                    
                    break
                case .finishing:
                    
                    break
                default:
                    
                    break
                }
            }
            recognitionTask = nil
            request = nil
        }
    }
    
    func dismissRecoderView() {
        if speechView != nil {
            speechView.removeFromSuperview()
            speechView.delegate = nil
            speechView = nil
        }
    }
        
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            self.showSpeechAlert(alertType: .functionError)
        }
    }
    
}

extension SpeechViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: speechTextView.frame.size.width, height: .infinity)
        let estimatedSize = speechTextView.sizeThatFits(size)
        speechTextView.heightAnchor.constraint(equalToConstant: estimatedSize.height).isActive = true
        speechTextViewHeightConstraint.constant = estimatedSize.height
        if estimatedSize.height < 128 {
            speechTextViewHeightConstraint.constant = 128
        }
    }
    
}
