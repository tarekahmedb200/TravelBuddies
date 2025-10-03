//
//  ImageCompressor.swift
//  TavelsBuddies
//
//  Created by tarek on 26/09/2025.
//

import Foundation
import UIKit


enum ImageCompressor {
    static func resizeAndCompress(_ data: Data, maxSize: CGFloat = 720) async -> Data? {
        // 1. Convert Data -> UIImage
        guard let uiImage = UIImage(data: data) else { return nil }
        
        // 2. Calculate how much we need to scale down
        let scale = maxSize / max(uiImage.size.width, uiImage.size.height)
        let newSize = CGSize(width: uiImage.size.width * scale,
                             height: uiImage.size.height * scale)
        
        // 3. Draw the image into a new context with the smaller size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        uiImage.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 4. Compress into JPEG data with 80% quality
        return resized?.jpegData(compressionQuality: 0.8)
    }
}

