//
//  PhotoBoyTests.swift
//  PhotoBoyTests
//
//  Created by Brandon Aubrey on 2/20/25.
//

import Testing
import UIKit
@testable import PhotoBoy

struct PhotoBoyTests {
    
    
    @Suite("Processing Tests") struct ImageProcessingTests {
        let image = UIImage(systemName: "wave.3.right")!
        
        @Test func aButtonNoImage() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.aButtonAction()
            #expect(viewModel.presentingImage == nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func bButtonNoImage() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.bButtonAction()
            #expect(viewModel.presentingImage == nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func processImage() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            #expect(viewModel.originalImage != nil)
        }
        
        @Test func removeProcessedImage() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func removeOriginalImage() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.bButtonAction()
            #expect(viewModel.presentingImage == nil)
        }
        
        @Test func pickerPickerProcess() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage != nil)
        }
        
        @Test func pickerProcessPicker() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.selectButtonAction(selectButtonObject: image)
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessRemovePicker() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.selectButtonAction(selectButtonObject: image)
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessRemoveRemove() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.bButtonAction()
            #expect(viewModel.presentingImage == nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessRemoveRemovePicker() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.bButtonAction()
            viewModel.bButtonAction()
            viewModel.selectButtonAction(selectButtonObject: image)
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage == nil)
        }
        
        @Test func pickerProcessPickerProcess() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.aButtonAction()
            #expect(viewModel.presentingImage != nil)
            #expect(viewModel.originalImage != nil)
        }
    }
    
    @Suite("Test Directional Pad Actions") struct DirectionPadTests {
        let image = UIImage(systemName: "wave.3.right")!
        
        @Test func testNoChangeOnNilImageContrast() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.directionPadAction(direction: .right)
            #expect(viewModel.contrast == 1.0)
            viewModel.directionPadAction(direction: .left)
            viewModel.directionPadAction(direction: .left)
            #expect(viewModel.contrast == 1.0)
        }
        
        @Test func testNoChangeOnNilImageBrightness() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.directionPadAction(direction: .up)
            #expect(viewModel.brightness == 0.0)
            viewModel.directionPadAction(direction: .down)
            viewModel.directionPadAction(direction: .down)
            #expect(viewModel.brightness == 0.0)
        }

        @Test func testContrastChange() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.directionPadAction(direction: .right)
            #expect(viewModel.contrast == 1.1)
            viewModel.directionPadAction(direction: .left)
            viewModel.directionPadAction(direction: .left)
            #expect(viewModel.contrast == 0.9)
        }
        
        @Test func testBrightnessChange() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            viewModel.directionPadAction(direction: .up)
            #expect(viewModel.brightness == 0.1)
            viewModel.directionPadAction(direction: .down)
            viewModel.directionPadAction(direction: .down)
            #expect(viewModel.brightness == -0.1)
        }
        
        @Test func testBrightnessUpperLimit() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            for _ in 0..<15 {
                viewModel.directionPadAction(direction: .up)
            }
            #expect(viewModel.brightness.rounded(.up) == 1.0)
        }
        
        @Test func testBrightnessLowerLimit() async throws {
            let viewModel = PhotoBoyViewModel()
            viewModel.selectButtonAction(selectButtonObject: image)
            for _ in 0..<15 {
                viewModel.directionPadAction(direction: .down)
            }
            #expect(viewModel.brightness.rounded(.down) == -1.0)
        }
    }
}
