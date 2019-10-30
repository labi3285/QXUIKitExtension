//
//  QXGif.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

extension UIImage {
    
    public func qxMakeGifData() -> Data? {
        
        guard let images = images else {
            return nil
        }

        let frameCount = images.count
        let gifDuration = duration / Double(frameCount)

        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: gifDuration]]
        let imageProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]

        let data = NSMutableData()
        
        guard let destination = CGImageDestinationCreateWithData(data, kUTTypeGIF, frameCount, nil) else {
            return nil
        }
        CGImageDestinationSetProperties(destination, imageProperties as CFDictionary)

        for image in images {
            CGImageDestinationAddImage(destination, image.cgImage!, frameProperties as CFDictionary)
        }

        return CGImageDestinationFinalize(destination) ? data as Data : nil
    }
    
    public static func qxGifImageWithData(_ gifData: Data, scale: CGFloat) -> UIImage? {
        let options: NSDictionary = [
            kCGImageSourceShouldCache as String: true,
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]
        guard let imageSource = CGImageSourceCreateWithData(gifData as NSData, options) else {
            return nil
        }

        let frameCount = CGImageSourceGetCount(imageSource)
        var images = [UIImage]()

        var gifDuration = 0.0

        for i in 0..<frameCount {
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, options) else {
                return nil
            }
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil),
                let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else
            {
                return nil
            }
            gifDuration += frameDuration.doubleValue
            images.append(UIImage(cgImage: imageRef, scale: scale, orientation: .up))
        }

        if (frameCount == 1) {
            return images.first
        } else {
            return UIImage.animatedImage(with: images, duration: gifDuration)
        }
    }
    
    
}
