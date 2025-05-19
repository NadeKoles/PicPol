//
//  TextOverlayView.swift
//  PicPol
//
//  Created by Nadia on 18/05/2025.
//

import SwiftUI

struct TextOverlayView: View {
    @ObservedObject var viewModel: TextOverlayViewModel

    @State private var isEditing = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        if let overlay = viewModel.textOverlay {
            Group {
                if isEditing {
                    
                    // MARK: - Text Field Input
                    TextField("Enter text", text: Binding(
                        get: { overlay.text },
                        set: { viewModel.textOverlay?.text = $0 }
                    ))
                    .font(.custom(overlay.fontName, size: overlay.fontSize))
                    .foregroundColor(Color(hex: overlay.colorHex, alpha: overlay.alpha))
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                } else {
                    
                    // MARK: - Display Mode
                    Text(overlay.text)
                        .font(.custom(overlay.fontName, size: overlay.fontSize))
                        .foregroundColor(Color(hex: overlay.colorHex, alpha: overlay.alpha))
                        .onTapGesture(count: 2) {
                            if viewModel.isAddingText {
                                isEditing = true
                            }
                        }
                }
            }
            .offset(x: overlay.position.width + dragOffset.width,
                    y: overlay.position.height + dragOffset.height)
            .gesture(
                viewModel.isAddingText ? DragGesture()
                    .onChanged { drag in
                        dragOffset = drag.translation
                    }
                    .onEnded { drag in
                        viewModel.textOverlay?.position.width += drag.translation.width
                        viewModel.textOverlay?.position.height += drag.translation.height
                        dragOffset = .zero
                    }
                : nil
            )
        }
    }
    
    
}
