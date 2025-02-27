//
//  ImageProcessor.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/21/25.
//

import Accelerate

public enum ImageProperties {
    public static let width = 160
    public static let height = 144
}

extension CGImage {
    
    
    /// This stream takes the image and makes it a grayscale while 2 bit channels (00, 01, 10, 11) ie 4 different shades of gray
    /// It also reduces it to a 160x144 image which is what the original gameboys were
    
    public func reduceAndDither() throws -> CGImage {
        // Declare the three coefficients that model the eye's sensitivity
        // to color.
        
        let redCoefficient: Float = 0.2126
        let greenCoefficient: Float = 0.7152
        let blueCoefficient: Float = 0.0722
        
        // Create a 1D matrix containing the three luma coefficients that
        // specify the color-to-grayscale conversion.
        let divisor: Int32 = 0x1000
        let fDivisor = Float(divisor)
        
        var coefficientsMatrix = [
            Int16(redCoefficient * fDivisor),
            Int16(greenCoefficient * fDivisor),
            Int16(blueCoefficient * fDivisor),
        ]
        
        // Use the matrix of coefficients to compute the scalar luminance by
        // returning the dot product of each RGB pixel and the coefficients
        // matrix.
        let preBias: [Int16] = [0, 0, 0, 0]
        let postBias: Int32 = 0
        
        
        // Create buffers
        var sourceBuffer = try vImageGetSourceBuffer()
        var destinationBuffer = try vImageGetDestBuffer(fromSourceBuffer: sourceBuffer, bitsPerPixel: 8)
        var destinationBuffer2 = try vImageGetDestBuffer(fromSourceBuffer: sourceBuffer, bitsPerPixel: 2)
        
        // Convert from RGB to gray scale
        vImageMatrixMultiply_ARGB8888ToPlanar8(&sourceBuffer,
                                               &destinationBuffer,
                                               &coefficientsMatrix,
                                               divisor,
                                               preBias,
                                               postBias,
                                               vImage_Flags(kvImageNoFlags))
        
        
        // convert from 8 bit channel to 2 bit channel
        // add Floyd Steinberg dithering to make image look better
  
        vImageConvert_Planar8toPlanar2(
            &destinationBuffer,
            &destinationBuffer2,
            nil,
            Int32(kvImageConvert_DitherFloydSteinberg),
            vImage_Flags(kvImageNoFlags)
        )
        
        // Create a 2-channel, 8-bit grayscale format that's used to
        // generate a displayable image.
        guard let monoFormat = vImage_CGImageFormat(
            bitsPerComponent: 2,
            bitsPerPixel: 2,
            colorSpace: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
            renderingIntent: .defaultIntent
        ) else {
            throw ImageProcessorError.unknownFormat
        }
        
        
        // Create a Core Graphics image from the grayscale destination buffer.
        return try destinationBuffer2.createCGImage(format: monoFormat)
    }
}

private extension CGImage {
    
    func vImageGetFormat() throws -> vImage_CGImageFormat {
        guard let format = vImage_CGImageFormat(cgImage: self) else {
            throw ImageProcessorError.unknownFormat
        }
        return format
    }
    
    func vImageGetSourceBuffer() throws -> vImage_Buffer {
        let format = try vImageGetFormat()
        var sourceImageBuffer = try vImage_Buffer(cgImage: self, format: format)

        
        var scaledBuffer = try vImage_Buffer(width: ImageProperties.width,
                                             height: ImageProperties.height,
                                             bitsPerPixel: format.bitsPerPixel)
        defer {
            sourceImageBuffer.free()
        }
        vImageScale_ARGB8888(&sourceImageBuffer,
                             &scaledBuffer,
                             nil,
                             vImage_Flags(kvImageNoFlags))
        return scaledBuffer
    }
    
    
    func vImageGetDestBuffer(fromSourceBuffer sourceBuffer: vImage_Buffer, bitsPerPixel: UInt32) throws -> vImage_Buffer {
        try vImage_Buffer(
            width: ImageProperties.width,
            height: ImageProperties.height,
            bitsPerPixel: bitsPerPixel
        )
    }
}
