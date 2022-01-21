//
//  ViewController.swift
//  Syllabite UI & Package Testing
//
//  Created by Anthony Foli on 12/25/21.
//

import UIKit
import SwiftttCamera
import Vision


var ocrWords : String = ""
let wordsPath = Bundle.main.path(forResource: "words", ofType: "txt") // file path for file"data.txt"
let finalWordsPath = Bundle.main.path(forResource: "finishedwords", ofType: "txt")
let words  = try! String(contentsOfFile: wordsPath!, encoding: String.Encoding.utf8).split(whereSeparator: \.isNewline).map { String($0) }
let finalWords = try! String(contentsOfFile: finalWordsPath!, encoding: String.Encoding.utf8).split(whereSeparator: \.isNewline).map { String($0) }
var readyWords : String = ""


class ViewController: UIViewController {
    
    private lazy var camera: SwiftttCamera = {
            let result = SwiftttCamera()
            result.delegate = self
            result.view.translatesAutoresizingMaskIntoConstraints = false
            return result
        }()
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swiftttAddChild(camera)
        camera.view.frame = view.frame
        view.addSubview(shutterButton)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for:.touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y:view.frame.size.height - 100)
    }
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
         let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        // Process the recognized strings.
        ocrWords = ""
        ocrWords.append(recognizedStrings.joined(separator: " "))
        ocrWords = ocrWords.lowercased()
        
        let iniWords = ocrWords.components(separatedBy: " ")
        for word in iniWords {
        var counter = 0
        var breakLoop = false
            while (breakLoop == false)
            {
                if (word == words[counter])
                {
                    readyWords.append(finalWords[counter] + " ")
                    print(finalWords[counter])
                    counter = 0
                    breakLoop = true
                } else if counter >= 370095 {
                    print("could not find word")
                    readyWords.append(word + " ")
                    breakLoop = true
                }
            counter+=1
            }
        }
    }
    @objc private func didTapTakePhoto()
    {
        camera.takePicture()
        readyWords = ""
        
    }
}

extension ViewController : CameraDelegate {
    func cameraController(_ cameraController: CameraProtocol, didFinishNormalizingCapturedImage capturedImage: CapturedImage)
    {
        guard let cgImage = capturedImage.fullImage.cgImage else {return}
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        
        do {
            try requestHandler.perform([request])
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistorySB") as! HistoryViewController
            self.present(newViewController, animated: true, completion: nil)
            
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
}

