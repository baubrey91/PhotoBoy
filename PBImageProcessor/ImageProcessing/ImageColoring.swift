//
//  ImageColoring.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/23/25.
//

import SwiftUI

extension CGImage {
    
    /// This function works by going creating a buffer of all pixels, look at each pixel and determinind what color it is similiar to (I used a 1:1 mapping not a calculation
    /// From there we replace the pixel with the coresponding green one
    
    public func applyFilter() throws -> CGImage {
        
        let cgImage = self
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let width = Int(self.width)
        let height = Int(self.height)
        let bytesPerRow = width * 4
        
        // Allocate memory
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
        
        // Here is the main component where we iterate each pixel and map it to a new color
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                guard let greyPixel = GreyScalePixelValues(rawValue: pixels[index].value) else {
                    throw ImageProcessorError.colorMapping
                }
                pixels[index] = greyPixel.colorCorrespondent()
            }
        }
        
        // Now we turn the buffer to a new CGImage
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
}
