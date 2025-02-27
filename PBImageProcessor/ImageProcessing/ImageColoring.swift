//
//  ImageColoring.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/23/25.
//

import SwiftUI

extension CGImage {
    
    public func applyFilter() throws -> CGImage {
        
        let cgImage = self
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let width = Int(self.width)
        let height = Int(self.height)
        let bytesPerRow = width * 4
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        guard let imageContext = CGContext(
            data: imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            throw ImageProcessorError.makeImageContext
        }
        
        imageContext.draw(
            cgImage,
            in: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )
        
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                guard let greyPixel = GreyScalePixelValues(rawValue: pixels[index].value) else {
                    throw ImageProcessorError.colorMapping
                }
                pixels[index] = greyPixel.colorCorrespondent()
            }
        }
        
        guard let context = CGContext(
            data: pixels.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else {
            throw ImageProcessorError.makeContext
        }
        
        guard let newCGImage = context.makeImage() else {
            throw ImageProcessorError.makeImage
        }
        return newCGImage
    }
 
//    public var asImage: Image {
//        return Image(uiImage: UIImage(cgImage: self))
//    }
}

extension CGImage {
    // TODO: - Move to image processor
    public func cropImage() -> CGImage? {
        
        let correctRatio = ImageProperties.height / ImageProperties.width
        let scale = self.height / self.width
        
        guard scale != correctRatio else {
//            self = image
            return self
        }

        let cropHeight = scale > correctRatio
        let height = cropHeight ? self.width * correctRatio : self.height
        let width = cropHeight ? self.width : self.height * correctRatio
        let origin = CGPoint(
            x: cropHeight ? 0 : (self.width - width) / 2,
            y: cropHeight ? (self.height - height) / 2 : 0
        )
        let size = CGSize(width: cropHeight ? self.width : width, height: cropHeight ? height : self.height)
        
        guard let croppedImage = self.cropping(to: CGRect(origin: origin, size: size)) else {
//            error = PBError.cropping
            
//            presentingImage = nil
            // TODO: - Return nil
            return self
        }
        
        return croppedImage
//        presentingImage = croppedImage
    }
}
