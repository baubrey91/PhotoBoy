//
//  PBImageProcessorTests.swift
//  PBImageProcessorTests
//
//  Created by Brandon Aubrey on 2/24/25.
//

import Testing
import UIKit
@testable import PBImageProcessor

struct PBImageProcessorTests {

    @Test func example() async throws {
        let image = UIImage(systemName: "wave.3.right")!.cgImage!
        let reducedImage = try!image.reduceAndDither()
        #expect(reducedImage.bitsPerPixel == 8)
    }

}
