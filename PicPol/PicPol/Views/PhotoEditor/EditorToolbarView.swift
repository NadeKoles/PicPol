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
    var canvasSize: CGSize

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
                    // Cycle through filters
                    filterVM.cycleFilter()
                    
                    if let filtered = filterVM.filteredImage {
                        editorVM.selectedImage = filtered
                    }
                }
                
                ToolButton(systemName: "textformat", isActive: false) {
                    textVM.textOverlay = TextOverlay(text: "Text")
                    textVM.isAddingText = true 
                    onTextTapped()
                }
                
                ToolButton(systemName: "pencil.tip", isActive: editorVM.isDrawing) {
                    editorVM.isDrawing.toggle()
                }

                ToolButton(systemName: "arrow.counterclockwise.circle", isActive: false) {
                    editorVM.resetTransformations()
                    textVM.reset()                    
                    filterVM.reset()
                    // Reset to the truly original image (without any baked text)
                    if let original = filterVM.originalBaseImage {
                        editorVM.resetHistory(with: original)
                    }
                }
            }
            .padding()
        }
        .frame(height: 80)
    }
}

