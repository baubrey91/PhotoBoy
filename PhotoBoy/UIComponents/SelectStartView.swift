//
//  SelectStartView.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUICore
//import SwiftUI
//
//#Preview {
//    SelectStartView(text: "Select")
//}

struct SelectStartView: View {
    let text: String

    var body: some View {
        VStack {
            Capsule()
                .frame(width: Styler.frame.width, height: Styler.frame.height)
                .foregroundColor(Styler.capsuleForegroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: Styler.cornerRadius)
                        .stroke(Styler.border.color, lineWidth: Styler.border.lineWidth)
                }

            Text(text.uppercased())
                .font(Styler.font)
                .foregroundColor(Styler.textForegroundColor)
        }
    }
}

private enum Styler {
    static let frame = (width: 50.0, height: 10.0)
    static let capsuleForegroundColor = Color.gray.opacity(0.9)
    static let cornerRadius: CGFloat = 16
    static let border = (color: Color.black, lineWidth: 2.0)
    static let font: Font = .custom("Retro Gaming", size: 12.0)
    static let textForegroundColor: Color = .black.opacity(0.3)
}



