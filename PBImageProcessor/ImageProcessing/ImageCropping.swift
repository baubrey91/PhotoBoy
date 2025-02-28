//
//  ImageCropping.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/26/25.
//

import CoreGraphics

extension CGImage {
    public func cropImage() throws -> CGImage? {
        
        let correctRatio = ImageProperties.height / ImageProperties.width
        let originalWidth = CGFloat(self.width)
        let originalHeight = CGFloat(self.height)
        let scale = originalHeight / originalWidth
        
        // If image is correct ratio no need to crop
        guard scale != correctRatio else {
            return self
        }

        // Ff scale is larger than ratio we need to crop the top and bottom else left and right sides
        let cropHeight = scale > correctRatio
        let height = cropHeight ? originalWidth * correctRatio : originalHeight
        let width = cropHeight ? originalWidth : originalHeight * correctRatio
        
        // Find center
        let origin = CGPoint(
            x: cropHeight ? 0 : (originalWidth - width) / 2,
            y: cropHeight ? (originalHeight - height) / 2 : 0
        )
        let size = CGSize(width: cropHeight ? originalWidth : width, height: cropHeight ? height : originalHeight)
        
        // This finds a frame within the image and turns it into a CGImage
        guard let croppedImage = self.cropping(to: CGRect(origin: origin, size: size)) else {
            throw ImageProcessorError.cropping
        }
        
        return croppedImage
    }
}
