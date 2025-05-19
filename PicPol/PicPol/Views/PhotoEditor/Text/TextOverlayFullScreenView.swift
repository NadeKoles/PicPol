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
    let backgroundImage: UIImage

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Image(uiImage: backgroundImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            TextOverlayView(viewModel: viewModel)

            VStack {
                EditorOverlayHeaderView(
                    title: "Text Mode",
                    canUndo: false,
                    canRedo: false,
                    onUndo: {},
                    onRedo: {},
                    onCancel: {
                        viewModel.isAddingText = false   // сброс при отмене
                        viewModel.reset() 
                        dismiss()
                    },
                    onDone: {
                        viewModel.isAddingText = false   // сброс при сохранении
                        editorVM.applyText(from: viewModel)
                        viewModel.reset()  
                        dismiss()
                    }
                )
                Spacer()
                
                TextToolsView(viewModel: viewModel)
            }
        }
    }
}


