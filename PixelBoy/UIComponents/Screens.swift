//
//  Screens.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/24/25.
//

import SwiftUICore

//import SwiftUI
//
//#Preview {
//    ZStack {
//        TextScreen(textScreenType: .controls, dimensions: (350, 350))
//    }
//}

enum TextScreenType {
    case controls
    case saveComplete
}

struct TextScreen: View {
    let textScreenType: TextScreenType
    let dimensions: (width: CGFloat, height: CGFloat)
    var body: some View {
        Rectangle()
            .fill(Color.pbGreen)
            .frame(width: dimensions.width, height: dimensions.height)
        VStack(spacing: Styler.screenPadding) {
            switch textScreenType {
            case .controls:
                Text(Styler.aButtonText)
                    .modifier(RetroText(width: dimensions.width))
                Text(Styler.bButtonText)
                    .modifier(RetroText(width: dimensions.width))
                Text(Styler.selectButtonText)
                    .modifier(RetroText(width: dimensions.width))
                Text(Styler.startButtonText)
                    .modifier(RetroText(width: dimensions.width))
                Text(Styler.upDownText)
                    .modifier(RetroText(width: dimensions.width))
                Text(Styler.leftRightText)
                    .modifier(RetroText(width: dimensions.width))
            case .saveComplete:
                Text(Styler.saveCompleteText)
                    .modifier(RetroText(width: dimensions.width))
            }
        }
    }
}

struct ErrorScreen: View {
    var dimensions: (width: CGFloat, height: CGFloat)
    var error: Error
    var body: some View {
        Rectangle()
            .fill(Color.pbGreen)
            .frame(width: dimensions.width, height: dimensions.height)
        Text(Styler.errorText + (error.localizedDescription))
            .modifier(RetroText(width: dimensions.width - Styler.padding))
    }
}

struct RetroText: ViewModifier {
    let width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Styler.font)
            .frame(width: width, alignment: .leadingLastTextBaseline)
            .foregroundColor(Styler.screenColor)
    }
}


struct PowerOn: ViewModifier {
    var isOn: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            if isOn {
                content
                    .frame(width: Styler.powerFrame, height: Styler.powerFrame)
                    .foregroundColor(Styler.powerOnColor)
            } else {
                content
                    .frame(width: Styler.powerFrame, height: Styler.powerFrame)
                    .foregroundColor(Styler.powerOffColor)
            }
        }
    }
}

private enum Styler {
    // Text
    static let aButtonText = "A: Process Image"
    static let bButtonText = "B: Original Image"
    static let selectButtonText = "Select: Import Image"
    static let startButtonText = "Start: Export Image"
    static let upDownText = "Up/Down: Brightness"
    static let leftRightText = "Left/Right: Contrast"
    static let saveCompleteText = "Save Complete!\nPress B Button"
    
    static let screenPadding = 14.0
    static let errorText = "Error: "
    
    static let font: Font = .custom("Retro Gaming", size: 12.0)
    static let screenColor = Color.pbBlackGreen.opacity(0.8)
    static let padding = 40.0
    
    
    static let powerFrame = 8.0
    static let powerOnColor = Color.red.opacity(0.95)
    static let powerOffColor = Color.gray.opacity(0.95)

}
