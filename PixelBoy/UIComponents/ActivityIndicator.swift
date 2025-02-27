//
//  ActivityIndicator.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/27/25.
//

import SwiftUICore
struct ActivityIndicator: View {
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { (geo: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(
                            width: geo.size.width / Styler.frameDivisor,
                            height: geo.size.height / Styler.frameDivisor
                        )
                        .scaleEffect(Styler.scaleEffect(isAnimating: isAnimating, index: index))
                        .offset(y: Styler.offSet(geometry: geo))
                }.frame(width: geo.size.width, height: geo.size.height)
                    .rotationEffect(!self.isAnimating ? Styler.notRotation : Styler.fullRotation)
                    .animation(
                        Animation
                            .timingCurve(
                                Styler.timingCurveFirst,
                                Styler.timingCurveSecond(index: Double(index)),
                                Styler.timingCurveThird,
                                Styler.timingCurveFourth,
                                duration: Styler.animationDuration
                            )
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }
    }
}

private enum Styler {
    static let frameDivisor = 10.0
    static let notRotation: Angle = .degrees(0)
    static let fullRotation: Angle = .degrees(360)
    
    static let timingCurveFirst = 0.5
    static func timingCurveSecond(index: Double) -> Double {
        0.15 + index / 5.0
    }
    static let timingCurveThird = 1.0
    static let timingCurveFourth = 1.5
    
    static let animationDuration = 1.5
    
    static func scaleEffect(isAnimating: Bool, index: Int) -> CGFloat {
        return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }
    
    static func offSet(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 10 - geometry.size.height / 4
    }
}
