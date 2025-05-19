//
//  EditorToolbarView.swift
//  PicPol
//
//  Created by Nadia on 17/05/2025.
//

import SwiftUI

struct EditorToolbarView: View {
    // MARK: - Props
    
    @ObservedObject var editorVM: PhotoEditorViewModel
    @ObservedObject var filterVM: FilterViewModel
    @ObservedObject var textVM: TextOverlayViewModel
    
    var onTextTapped: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            // MARK: - Buttons
            HStack(spacing: 18) {
                ToolButton(systemName: "arrow.counterclockwise", isActive: false) {
                    withAnimation {
                        editorVM.rotationAngle += .degrees(90)
                        editorVM.commitChange()
                    }
                }
                
                ToolButton(systemName: "hand.draw", isActive: editorVM.isDragging) {
                    editorVM.isDragging.toggle()
                }

                ToolButton(systemName: "camera.filters", isActive: false) {
                    // Впечатываем рисунок перед фильтрацией
                    editorVM.drawingVM.applyDrawingToImage(
                        baseImage: editorVM.selectedImage,
                        canvasSize: CGSize(width: 300, height: 300), // при желании заменить на реальный canvasSize
                        rotationAngle: editorVM.rotationAngle,
                        offset: editorVM.imageOffset,
                        scale: editorVM.imageScale,
                        commit: editorVM.commitChange,
                        setResult: { editorVM.selectedImage = $0 }
                    )

                    filterVM.setOriginalImage(editorVM.selectedImage!)
                    filterVM.applyNextFilter()

                    if let filtered = filterVM.filteredImage {
                        editorVM.selectedImage = filtered
                        editorVM.commitChange()
                    }
                }

                
                ToolButton(systemName: "textformat", isActive: false) {
                    textVM.textOverlay = TextOverlay(text: "Text")
                    textVM.isAddingText = true 
                    onTextTapped()
                }
                
                // MARK: - Drawing Mode
                ToolButton(systemName: "pencil.tip", isActive: editorVM.isDrawing) {
                    editorVM.isDrawing.toggle()
                }

                ToolButton(systemName: "arrow.counterclockwise.circle", isActive: false) {
                    editorVM.resetTransformations()
                }
            }
            .padding()
        }
        .frame(height: 80)
    }
}

