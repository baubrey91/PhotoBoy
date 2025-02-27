//
//  DirectionPad.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUI

enum TriangleDirection {
    case up
    case down
    case left
    case right
}

#Preview {
    DirectionPad(
        directionPadAction: {
            direction in print(direction)
        }
    )
}

struct DirectionPad: View {
    let directionPadAction: ((TriangleDirection) -> Void)
    
    var body: some View {
        VStack(spacing: Styler.spacing) {
            Button(action: {
                directionPadAction(.up)
            }) {
                Triangle(direction: .up)
                    .padding(Styler.padding)
            }
            .buttonRepeatBehavior(.enabled)
            .buttonStyle(DirectionButton(buttonSize: Styler.buttonSize))
            HStack(spacing: Styler.spacing) {
                Button(action: {
                    directionPadAction(.left)
                }) {
                    Triangle(direction: .left)
                        .padding(Styler.padding)
                }
                .buttonRepeatBehavior(.enabled)
                .buttonStyle(DirectionButton(buttonSize: Styler.buttonSize))
                Rectangle()
                    .frame(
                        width: Styler.buttonSize,
                        height: Styler.buttonSize
                    )
                    .opacity(Styler.opacity)
                Button(action: {
                    directionPadAction(.right)
                }) {
                    Triangle(direction: .right)
                        .padding(Styler.padding)
                }
                .buttonRepeatBehavior(.enabled)
                .buttonStyle(DirectionButton(buttonSize: Styler.buttonSize))
            }
            Button(action: {
                directionPadAction(.down)
            }) {
                Triangle(direction: .down)
                    .padding(Styler.padding)
            }
            .buttonRepeatBehavior(.enabled)
            .buttonStyle(DirectionButton(buttonSize: Styler.buttonSize))
        }
    }
}

struct DirectionButton: ButtonStyle {
    let buttonSize: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: buttonSize, height: buttonSize)
            .foregroundStyle(.gray)
            .scaleEffect(
                configuration.isPressed ? Styler.animationEnlarged : Styler.animationStandard)
            .animation(.easeOut(duration: Styler.animationDuration), value: configuration.isPressed)
            .buttonRepeatBehavior(.enabled)
            .background(
                Rectangle()
                    .frame(width: buttonSize, height: buttonSize)
                    .opacity(Styler.opacity)
            )
    }
}
    

struct Triangle: Shape {
    
    fileprivate let direction: TriangleDirection
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch direction {
        case .up:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        case .down:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        case .left:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        case .right:
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
        return path
    }
}

private enum Styler {
    static let buttonSize: CGFloat = 40
    static let opacity: CGFloat = 0.8
    static let padding: CGFloat = 7
    static let spacing: CGFloat = 0
    static let animationDuration: CGFloat = 0.2
    static let animationEnlarged: CGFloat = 1.2
    static let animationStandard: CGFloat = 1
}
