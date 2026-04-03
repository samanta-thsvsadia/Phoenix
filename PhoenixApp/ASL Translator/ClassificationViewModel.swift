
import Foundation
import UIKit
import CoreML
import Vision
import SwiftUI


class ClassificationViewModel: ObservableObject {
    
    private var model = ContentViewModel()
    
    
    @Published var classificationLabel: String = ""
    @Published var name: String = ""
    @Published var text: String = ""
    var onLoop = false
    let mlmodel = ASLHandPoseClassifier()
    
    @Published private var image: UIImage? = UIImage(named: "sample")
    @Published private var shouldPresentImagePicker = false
    @Published private var shouldPresentActionScheet = false
    @Published private var shouldPresentCamera = false
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    func classifyImage(tmpImage: UIImage) {
        let image = tmpImage
        let resizedImage = image.resizeImageTo(size: CGSize(width: 224, height: 224))
        let buffer = resizedImage?.convertToBuffer()
        if buffer == nil {
            print("Buffer is empty")
            return
        }
        //How many hands to detect
        handPoseRequest.maximumHandCount = 1
        guard let imageData = image.jpegData(compressionQuality: 0) else {
            return
        }
        let handler = VNImageRequestHandler(data: imageData, options: [:])
        do {
       
            try handler.perform([handPoseRequest])
          
            var prediction: String = ""
            let observation = handPoseRequest.results?.first
            if observation == nil {name = "Position your hand to the center of the screen"
                classificationLabel = ""
                
            }
            guard let keypointsMultiArray = try? observation?.keypointsMultiArray() else {
                name = "Position your hand to the center of the screen"
                classificationLabel =  ""
                return }
            let handPosePrediction = try mlmodel.prediction(poses: keypointsMultiArray)
            let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label]!
            prediction = handPosePrediction.label
            let shortConfidence = confidence.format(f: ".3")
            classificationLabel = "\(shortConfidence)"
            name = "\(prediction)"
            print(prediction)
            print(confidence)
            if confidence > 0.8 && name != "error" && name != "hold" && name != "nil" {
                text.append(prediction)
                print (text)
            }
            if confidence > 0.8 && name == "error" {
                text.removeLast()
            }
            
            if confidence > 0.8 && name == "hold" {
                text.append(" ")
            }
            
        } catch {
            print("Error")
        }
    }
    
    func callFunc() {
        if onLoop {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                if model.frame != nil {
                    classifyImage(tmpImage: UIImage(cgImage: model.frame!))
                    if onLoop {callFunc()}
                }
            }
            print("ERRORD404")
        } else {
            return
        }
    }
    
    
}
