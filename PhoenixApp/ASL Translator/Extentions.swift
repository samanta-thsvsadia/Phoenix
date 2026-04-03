//
//  Extentions.swift
//  PhoenixApp
//
//  Created by Sadia Thasina Samanta on 04/11/23.
//

import Foundation
import CoreGraphics
import VideoToolbox


extension Double {
   
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}



extension CGImage {
   
    static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
        guard let pixelBuffer = cvPixelBuffer else {
            return nil
        }
        
        var image: CGImage?
        VTCreateCGImageFromCVPixelBuffer(
            pixelBuffer,
            options: nil,
            imageOut: &image)
        return image
    }
}
