//
//  PhotoBoyViewModel.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUI
import PhotosUI
import PBImageProcessor

final class PhotoBoyViewModel: ObservableObject {
    
    // MARK: - Enums
    
    enum Sounds: String {
        case powerUp
        case powerDown
    }
    
    // MARK: - Published Properties
    
    @Published var presentingImage: CGImage? = nil// UIImage(named: "SampleImage")?.cgImage
    @Published var error: Error? = nil
    @Published var selectedImage: PhotosPickerItem?
    @Published var contrast: CGFloat = 1
    @Published var brightness: CGFloat = 0.0
    @Published var loading = false
    
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
        let width = screenWidth * 0.6
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
        guard originalImage == nil,
              let image = presentingImage else { return }
        originalImage = presentingImage
        playSound(sound: .powerUp)

//        let start = CFAbsoluteTimeGetCurrent()
//        let grayScaleTime = CFAbsoluteTimeGetCurrent() - start
//        print("Took \(grayScaleTime) seconds")
            
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
        guard presentingImage != nil else { return }
        playSound(sound: .powerDown)

        if originalImage == nil {
            presentingImage = nil
            selectedImage = nil
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
    
    func selectButtonAction(selectButtonObject: Any) {
        guard let image = selectButtonObject as? UIImage,
              let cgImage = image.cgImage else { return }
        originalImage = nil
        presentingImage = cgImage.cropImage()
//        cropImage(image: cgImage)
    }
    
    func startButtonAction() {
        if let image = imageAsUIImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    func imageImported() {
        Task {
            guard let data = try? await selectedImage?.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                error = PBError.loadTranser
                return
            }
                
            await MainActor.run {
                originalImageOrentation = image.imageOrientation
                selectButtonAction(selectButtonObject: image)
            }
        }
    }
}

private extension PhotoBoyViewModel {
    
    func playSound(sound: Sounds) {
        if let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") {
            player = try? AVAudioPlayer(contentsOf: soundURL)
            player?.play()
        }
    }
}
