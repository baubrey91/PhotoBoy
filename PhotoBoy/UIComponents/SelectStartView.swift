//
//  SelectStartView.swift
//  PhotoBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUICore
import SwiftUI

#Preview {
    SelectStartView(text: "Select")
}

struct SelectStartView: View {
    let text: String

    var body: some View {
        VStack {
            Capsule()
                .frame(width: 50, height: 10)
                .foregroundColor(.gray.opacity(0.9))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 2)
                }

            Text(text.uppercased())
                .font(.custom("Retro Gaming", size: 12))
                .foregroundColor(.black.opacity(0.3))
        }
    }
}



