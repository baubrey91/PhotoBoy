//
//  ImageProcessorError.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/24/25.
//

enum ImageProcessorError: Error {
    case unknownFormat
    case makeImageContext
    case makeContext
    case colorMapping
    case makeImage
    case cropping
}
