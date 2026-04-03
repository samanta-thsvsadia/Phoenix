//
//  FrameManager.swift
//  PhoenixApp
//
//  Created by Sadia Thasina Samanta on 04/11/23.
//

import AVFoundation
import SwiftUI

class FrameManager: NSObject, ObservableObject {

    @EnvironmentObject var classificationViewModel : ClassificationViewModel
    
    static let shared = FrameManager()
  
    @Published var current: CVPixelBuffer?
   
    let videoOutputQueue = DispatchQueue(
        label: "com.raywenderlich.VideoOutputQ",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
 
    private override init() {
        super.init()
        CameraManager.shared.set(self, queue: videoOutputQueue)
    }
}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}
