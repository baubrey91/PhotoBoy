//
//  PixelBoyTests.swift
//  PixelBoyTests
//
//  Created by Brandon Aubrey on 2/20/25.
//

import Testing
import UIKit
@testable import PixelBoy

struct PixelBoyTests {
    
    @Suite("Processing Tests") struct ImageProcessingTests {
        
        func importImage(viewModel: PixelBoyViewModel) {
            // Crop cannot be handled in tests
            // Hack for now later import proper image that can crop
            let image = UIImage(systemName: "wave.3.right")!.cgImage!
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.originalImage = nil
            viewModel.error = nil
            viewModel.presentingImage = image
        }
        
        @Test func aButtonNoImage() async throws {
            let viewModel = PixelBoyViewModel()
            viewModel.aButtonAction()
            #expect(viewModel.presentingImage == nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func bButtonNoImage() async throws {
            let viewModel = PixelBoyViewModel()
            viewModel.bButtonAction()
            #expect(viewModel.presentingImage == nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func processImage() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            #expect(viewModel.originalImage != nil)
        }
        
        @Test func removeProcessedImage() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func removeOriginalImage() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.bButtonAction()
            #expect(viewModel.presentingImage == nil)
        }
        
        @Test func pickerPickerProcess() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage != nil)
        }
        
        @Test func pickerProcessPicker() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            importImage(viewModel: viewModel)
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessRemovePicker() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            importImage(viewModel: viewModel)
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessRemoveRemove() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.bButtonAction()
            #expect(viewModel.presentingImage == nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessRemoveRemovePicker() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.bButtonAction()
            importImage(viewModel: viewModel)
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessPickerProcess() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            importImage(viewModel: viewModel)
            viewModel.aButtonAction()
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage != nil)
        }
    }
    
    @Suite("Test Directional Pad Actions") struct DirectionPadTests {
        
        func importImage(viewModel: PixelBoyViewModel) {
            // Crop cannot be handled in tests
            let image = UIImage(systemName: "wave.3.right")!.cgImage!
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.originalImage = nil
            viewModel.error = nil
            viewModel.presentingImage = image
        }
        
        @Test func testNoChangeOnNilImageContrast() async throws {
            let viewModel = PixelBoyViewModel()
            viewModel.directionPadAction(direction: .right)
            #expect(viewModel.contrast == 1.0)
            viewModel.directionPadAction(direction: .left)
            viewModel.directionPadAction(direction: .left)
            #expect(viewModel.contrast == 1.0)
        }
        
        @Test func testNoChangeOnNilImageBrightness() async throws {
            let viewModel = PixelBoyViewModel()
            viewModel.directionPadAction(direction: .up)
            #expect(viewModel.brightness == 0.0)
            viewModel.directionPadAction(direction: .down)
            viewModel.directionPadAction(direction: .down)
            #expect(viewModel.brightness == 0.0)
        }

        @Test func testContrastChange() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.directionPadAction(direction: .right)
            #expect(viewModel.contrast == 1.1)
            viewModel.directionPadAction(direction: .left)
            viewModel.directionPadAction(direction: .left)
            #expect(viewModel.contrast == 0.9)
        }
        
        @Test func testBrightnessChange() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            viewModel.directionPadAction(direction: .up)
            #expect(viewModel.brightness == 0.1)
            viewModel.directionPadAction(direction: .down)
            viewModel.directionPadAction(direction: .down)
            #expect(viewModel.brightness == -0.1)
        }
        
        @Test func testBrightnessUpperLimit() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            for _ in 0..<15 {
                viewModel.directionPadAction(direction: .up)
            }
            #expect(viewModel.brightness.rounded(.up) == 1.0)
        }
        
        @Test func testBrightnessLowerLimit() async throws {
            let viewModel = PixelBoyViewModel()
            importImage(viewModel: viewModel)
            for _ in 0..<15 {
                viewModel.directionPadAction(direction: .down)
            }
            #expect(viewModel.brightness.rounded(.down) == -1.0)
        }
    }
}
