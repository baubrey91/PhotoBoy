//
//  PBButton.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUI

#Preview {
    Button("A") {
    }
    .buttonStyle(PBButton())
}


struct PBButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Styler.font)
            .foregroundColor(Styler.foregroundColor)
            .scaleEffect(
                configuration.isPressed ? Styler.scale.pressed : Styler.scale.default)
            .animation(.easeOut(duration: Styler.animationDuration), value: configuration.isPressed)
            .background(
                Circle()
                    .foregroundColor(Color.buttonPurple)
                    .frame(width: Styler.frame, height: Styler.frame)
                    .overlay {
                        Circle()
                            .stroke(Styler.stroke.color, lineWidth: Styler.stroke.width)
                    }
            )
            .padding(.trailing, Styler.padding)
    }
}

private enum Styler {
    static let font: Font = .custom("Retro Gaming", size: 24)
    static let foregroundColor: Color = .black.opacity(0.5)
    static let scale = (pressed: 1.2, default: 1.0)
    static let animationDuration = 0.2
    static let frame = 40.0
    static let stroke = (color: Color.black, width: 2.0)
    static let padding = 40.0
}



