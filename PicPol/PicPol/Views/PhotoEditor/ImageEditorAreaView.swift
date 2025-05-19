//
//  ImageEditorAreaView.swift
//  PicPol
//
//  Created by Nadia on 17/05/2025.
//

import SwiftUI

struct ImageEditorAreaView: View {
    let image: UIImage
    let usableSize: CGSize
    @ObservedObject var editorVM: PhotoEditorViewModel
    @ObservedObject var textVM: TextOverlayViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Base Image with Transformations
            ZStack {
                Spacer()
                
                AdaptiveImageContainer(
                    image: image,
                    isDraggable: editorVM.isDragging,
                    maxSize: usableSize,
                    rotationAngle: editorVM.rotationAngle,
                    onCommit: { editorVM.commitChange() },
                    offset: $editorVM.imageOffset,
                    scale: $editorVM.imageScale,
                    lastScale: $editorVM.lastScale
                )
                .frame(width: usableSize.width, height: usableSize.height)
                .clipped()
                
                Spacer()
            }
            
            // MARK: - Text Overlay Layer
            if textVM.textOverlay != nil {
                TextOverlayView(viewModel: textVM)
            }
        }
    }
}
