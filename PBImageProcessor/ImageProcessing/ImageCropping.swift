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
        let scale = self.height / self.width
        
        // If image is correct ratio no need to crop
        guard scale != correctRatio else {
            return self
        }

        // Ff scale is larger than ratio we need to crop the top and bottom else left and right sides
        let cropHeight = scale > correctRatio
        let height = cropHeight ? self.width * correctRatio : self.height
        let width = cropHeight ? self.width : self.height * correctRatio
        
        // Find center
        let origin = CGPoint(
            x: cropHeight ? 0 : (self.width - width) / 2,
            y: cropHeight ? (self.height - height) / 2 : 0
        )
        let size = CGSize(width: cropHeight ? self.width : width, height: cropHeight ? height : self.height)
        
        // This finds a frame within the image and turns it into a CGImage
        guard let croppedImage = self.cropping(to: CGRect(origin: origin, size: size)) else {
            throw ImageProcessorError.cropping
        }
        
        return croppedImage
    }
}
