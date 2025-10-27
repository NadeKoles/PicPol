//
//  TextOverlayFullScreenView.swift
//  PicPol
//
//  Created by Nadia on 18/05/2025.
//

import SwiftUI

struct TextOverlayFullScreenView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TextOverlayViewModel
    @ObservedObject var editorVM: PhotoEditorViewModel
    @ObservedObject var filterVM: FilterViewModel
    let backgroundImage: UIImage

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Image(uiImage: backgroundImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .rotationEffect(editorVM.rotationAngle)

            TextOverlayView(viewModel: viewModel)

            VStack {
                EditorOverlayHeaderView(
                    title: "Text Mode",
                    canUndo: false,
                    canRedo: false,
                    onUndo: {},
                    onRedo: {},
                    onCancel: {
                        viewModel.isAddingText = false  
                        viewModel.reset() 
                        dismiss()
                    },
                    onDone: {
                        if viewModel.textOverlay != nil {
                            editorVM.applyText(from: viewModel)
                            // Update filter's original image to include the baked text
                            if let updatedImage = editorVM.selectedImage {
                                filterVM.updateOriginalImage(updatedImage)
                            }
                            viewModel.reset()
                        }
                        viewModel.isAddingText = false
                        dismiss()
                    }
                )
                Spacer()
                
                TextToolsView(viewModel: viewModel)
            }
        }
    }
}


