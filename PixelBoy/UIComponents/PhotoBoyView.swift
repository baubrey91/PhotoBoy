//
//  PixelBoyView.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/20/25.
//

import SwiftUI
import PhotosUI

#Preview {
    PixelBoyView()
}

struct PixelBoyView: View {
    
    @StateObject private var viewModel = PixelBoyViewModel()
    @State private var showingOptions = false

    var body: some View {
        ZStack {
            Color.gameBoyGrey
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.darkGray)
                        .clipShape(
                            .rect(
                                topLeadingRadius: Styler.Screen.screenCorners.default,
                                bottomLeadingRadius: Styler.Screen.screenCorners.default,
                                bottomTrailingRadius: Styler.Screen.screenCorners.bottomRight,
                                topTrailingRadius: Styler.Screen.screenCorners.default
                            )
                        )
                    
                    // MARK: - Power indicator
                    VStack {
                        HStack {
                            VStack(alignment: .trailing) {
                                HStack(spacing: Styler.PowerIcon.spacing) {
                                    Circle()
                                        .modifier(PowerOn(isOn: viewModel.originalImage != nil))
                                    Image(systemName: Styler.PowerIcon.imageName)
                                        .foregroundColor(Styler.PowerIcon.foreGroundColor)
                                        .frame(width: Styler.PowerIcon.imageWidth)
                                }
                                Text(Styler.PowerIcon.titleText)
                                    .font(Styler.PowerIcon.font)
                                    .foregroundColor(Styler.PowerIcon.foreGroundColor)
                                    .padding(.leading, Styler.PowerIcon.padding)
                            }
                            Spacer()
                        }
                    }
                    
                    // MARK: - Screens
                    Rectangle()
                        .fill(Color.black)
                        .frame(
                            width: viewModel.imageDimensions.width + Styler.Screen.borderWidth,
                            height: viewModel.imageDimensions.height + Styler.Screen.borderWidth
                        )
                    if viewModel.saveFinishedSuccesfully {
                        TextScreen(textScreenType: .saveComplete, dimensions: viewModel.imageDimensions)
                    } else if let error = viewModel.error {
                        ErrorScreen(dimensions: viewModel.imageDimensions, error: error)
                    } else if let image = viewModel.imageAsUIImage {
                        Image(uiImage: image)
                                .resizable()
                                .frame(width: viewModel.imageDimensions.width, height: viewModel.imageDimensions.height)
                                .contrast(viewModel.contrast)
                                .brightness(viewModel.brightness)
                                .animation(
                                    .easeOut(
                                        duration: Styler.Screen.animationDuration
                                    ),
                                    value: viewModel.presentingImage
                                )
                                .clipped()
                    } else {
                        TextScreen(textScreenType: .controls ,dimensions: viewModel.imageDimensions)
                    }
                    if viewModel.isLoading {
                        ActivityIndicator()
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                }
                .frame(
                    width: viewModel.imageDimensions.width + Styler.Screen.screenWidthPadding,
                    height: viewModel.imageDimensions.height + Styler.Screen.screenHeightPadding)
                Text(Styler.productName)
                    .font(Styler.Logo.font)
                    .foregroundColor(Styler.Logo.foreground)
                    .background(
                        RoundedRectangle(cornerRadius: Styler.Logo.cornerRadius, style: .continuous)
                            .stroke(Styler.Logo.stroke, lineWidth: Styler.Logo.lineWidth)
                            .frame(
                                width: Styler.Logo.frame.width,
                                height: Styler.Logo.frame.height
                            )
                    )
                
                // MARK: - Pad and Buttons
                HStack {
                    DirectionPad(
                        directionPadAction: viewModel.directionPadAction
                    )
                    .frame(width: Styler.dPadWidth)
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button("B") {
                        viewModel.bButtonAction()
                    }
                    .buttonStyle(PBButton())
                    .offset(y: Styler.bButtonOffset)
                    
                    Button("A") {
                        viewModel.aButtonAction()
                    }
                    .buttonStyle(PBButton())
                }
                .padding(.top, Styler.buttonsPaddingTop)
                .padding(.bottom, Styler.buttonsPaddingBottom)
                
                // MARK: - Select Start buttons
                HStack {
                    PhotosPicker(
                        selection: $viewModel.selectedImage,
                        matching: .images
                    ) {
                        SelectStartView(text: Styler.AUXButtons.selectTitle)
                            .rotationEffect(Styler.AUXButtons.angle)
                    }
                    .onChange(of: viewModel.selectedImage) {
                        viewModel.imageImported()
                    }
                    Button {
                        showingOptions = true
                    } label: {
                        SelectStartView(text: Styler.AUXButtons.startTitle)
                            .rotationEffect(Styler.AUXButtons.angle)
                    }
                    .confirmationDialog(Styler.AUXButtons.actionSheetTitle, isPresented: $showingOptions, titleVisibility: .visible) {
                        Button(Styler.AUXButtons.saveTitle) {
                            viewModel.startButtonAction()
                        }
                        if let image = self.viewModel.imageAsUIImage {
                            ShareLink(
                                item: Image(uiImage: image),
                                preview: SharePreview(Styler.productName, image: Image(uiImage: viewModel.imageAsUIImage!))
                            )
                        }
                    }
                }
                
                // MARK: - Brightness Contrast indicators
                HStack {
                    Spacer()
                    VStack {
                        Text(viewModel.brightnessString)
                            .modifier(RetroText(width: viewModel.imageDimensions.width))
                        Text(viewModel.contrastString)
                            .modifier(RetroText(width: viewModel.imageDimensions.width))
                    }
                    .padding(.top, Styler.bottomPadding)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


private enum Styler {
    
    static let bButtonOffset: CGFloat = 30
    static let dPadWidth: CGFloat = 125
    static let buttonsPaddingTop = 25.0
    static let buttonsPaddingBottom = 40.0
    static let bottomPadding = 50.0
    static let productName = "Photo Boy"
    
    enum PowerIcon {
        static let imageName = "wave.3.right"
        static let titleText = "POWER"
        static let foreGroundColor: Color = .white.opacity(0.5)
        static let font: Font = .system(size: 12)
        static let spacing = 2.0
        static let imageWidth = 20.0
        static let padding = 4.0
    }
    
    enum Screen {
        static let screenCorners: (default: CGFloat, bottomRight: CGFloat) = (20, 60)
        static let borderWidth: CGFloat = 4
        static let animationDuration: CGFloat = 0.5
        static let screenWidthPadding: CGFloat = 120
        static let screenHeightPadding: CGFloat = 75
    }
    
    enum Logo {
        static let font: Font = .custom("Retro Gaming", size: 12)
        static let foreground = Color.black.opacity(0.3)
        static let cornerRadius = 10.0
        static let stroke = Color.black.opacity(0.25)
        static let lineWidth = 0.25
        static let frame = (width: 120.0, height: 30.0)
    }
    
    enum AUXButtons {
        static let selectTitle = "SELECT"
        static let startTitle = "START"
        static let angle = Angle(degrees: 325)
        static let actionSheetTitle = "Export Options"
        static let saveTitle = "Save"
    }
}

