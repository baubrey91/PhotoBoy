//
//  Screens.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/24/25.
//

import SwiftUICore

import SwiftUI

#Preview {
    ZStack {
        InstructionsScreen(dimensions: (350, 350))
    }
}

struct InstructionsScreen: View {
    var dimensions: (width: CGFloat, height: CGFloat)
    var body: some View {
        Rectangle()
            .fill(Color.pbGreen)
            .frame(width: dimensions.width, height: dimensions.height)
        VStack(alignment: .leading, spacing: 14) {
            Text("A: Process Image")
                .modifier(RetroText())
            Text("B: Original Image")
                .modifier(RetroText())
            Text("Select: Import Image")
                .modifier(RetroText())
            Text("Start: Export Image")
                .modifier(RetroText())
            Text("Up/Down: Brightness")
                .modifier(RetroText())
            Text("Left/Right: Contrast")
                .modifier(RetroText())
        }
    }
}

struct ErrorScreen: View {
    var dimensions: (width: CGFloat, height: CGFloat)
    var error: Error
    var body: some View {
        Rectangle()
            .frame(width: dimensions.width, height: dimensions.height)
        VStack() {
            Text("Error: \(error)")
                .modifier(RetroText())
        }
    }
}

struct RetroText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Retro Gaming", size: 12))
            .foregroundColor(Color.pbBlackGreen.opacity(0.8))
    }
}


struct PowerOn: ViewModifier {
    var isOn: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            if isOn {
                content
                    .frame(width: 8, height: 8)
                    .foregroundColor(.red.opacity(0.95))
            } else {
                content
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray.opacity(0.95))
            }
        }
    }
}

