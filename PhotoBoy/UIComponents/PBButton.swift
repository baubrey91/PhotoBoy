//
//  PBButton.swift
//  PhotoBoy
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
            .font(.custom("Retro Gaming", size: 24))
            .foregroundColor(.black.opacity(0.5))
            .scaleEffect(
                configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .background(
                Circle()
                    .foregroundColor(Color.buttonPurple)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                    }
            )
            .padding(.trailing, 40)
    }
}



