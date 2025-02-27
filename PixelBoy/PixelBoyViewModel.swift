//
//  PixelBoyViewModel.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUI
import PhotosUI
import PBImageProcessor

final class PixelBoyViewModel: NSObject, ObservableObject {
    
    // MARK: - Enums
    
    enum Sounds: String {
        case powerUp
        case powerDown
    }
    
    // MARK: - Published Properties
    
    @Published var presentingImage: CGImage? = nil
    @Published var selectedImage: PhotosPickerItem?
    @Published var contrast: CGFloat = 1
    @Published var brightness: CGFloat = 0.0
    @Published var loading = false
    @Published var error: Error? = nil
    @Published var saveFinishedSuccesfully = false
    @Published var isLoading = false
    
    // MARK: - Properties
    
    var originalImage: CGImage?
    private var player: AVAudioPlayer?
    private var originalImageOrentation: UIImage.Orientation = .up

    // MARK: - Computed Properties

    var imageAsUIImage: UIImage? {
        guard let cgImage = presentingImage else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImageOrentation)
    }
    
    var imageDimensions: (width: CGFloat, height: CGFloat) {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenSizeFactor = 0.6
        let width = screenWidth * screenSizeFactor
        let multiplier = CGFloat(ImageProperties.height) / CGFloat(ImageProperties.width)
        return (width, width * multiplier)
    }
    
    var brightnessString: String {
        return String(format: "Brightness: %.2f", brightness)
    }
    
    var contrastString: String {
        return String(format: "Contrast: %.2f", contrast)
    }
    
    // MARK: - "A" Button
    
    func aButtonAction()  {
        guard resetNotNeeded(),
              originalImage == nil,
              let image = presentingImage else { return }
       
        originalImage = presentingImage
        playSound(sound: .powerUp)
        
        do {
            let grayScaleImage = try image.reduceAndDither()
            presentingImage = try grayScaleImage.applyFilter()
        } catch let newError {
            // TODO: - Log Error
            error = newError
            originalImage = nil
            presentingImage = nil
        }
    }
    
    // MARK: - "B" Button
    
    func bButtonAction() {
        guard resetNotNeeded(),
              presentingImage != nil else { return }
        playSound(sound: .powerDown)

        if originalImage == nil {
            presentingImage = nil
            contrast = 1.0
            brightness = 0.0
        } else {
            presentingImage = originalImage
            originalImage = nil
        }
    }
    
    // MARK: - Direction Pad
    
    func directionPadAction(direction: TriangleDirection) {
        guard presentingImage != nil else { return }
        switch direction {
        case .up:
            guard brightness < 0.9 else { return }
            brightness += 0.1
        case .down:
            guard brightness > -0.9 else { return }
            brightness -= 0.1
        case .left:
            contrast -= 0.1
        case .right:
            contrast += 0.1
        }
    }
    
    // MARK: - Select Button

    func selectButtonAction(selectButtonObject: Any) {
        guard let image = selectButtonObject as? UIImage,
              let cgImage = image.cgImage else { return }
        originalImage = nil
        do {
            presentingImage = try cgImage.cropImage()
        } catch let newError {
            // TODO: - Log Error
            error = newError
        }
    }
    
    // MARK: - Start Button
    
    func startButtonAction() {
        guard resetNotNeeded() else { return }
        if let image = imageAsUIImage {
            isLoading = true
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        isLoading = false
        if let newError = error {
            self.error = newError
        } else {
            saveFinishedSuccesfully = true
        }
    }
    
    func imageImported() {
        resetNotNeeded()
        isLoading = true
        Task {
            guard let data = try? await selectedImage?.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                await MainActor.run {
                    error = PBError.loadTransfer
                    isLoading = false
                }
                return
            }
                
            await MainActor.run {
                originalImageOrentation = image.imageOrientation
                selectButtonAction(selectButtonObject: image)
                isLoading = false
            }
        }
    }
}

private extension PixelBoyViewModel {
    
    @discardableResult
    func resetNotNeeded() -> Bool {
        if saveFinishedSuccesfully {
            saveFinishedSuccesfully = false
            return false
        } else if error != nil {
            error = nil
            return false
        }
        return true
    }
    
    func playSound(sound: Sounds) {
        if let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") {
            player = try? AVAudioPlayer(contentsOf: soundURL)
            player?.play()
        }
    }
}
