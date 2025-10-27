//
//  DrawingOverlayView.swift
//  PicPol
//
//  Created by Nadia on 17/05/2025.
//

import SwiftUI
import PencilKit

struct DrawingOverlayView: View {
    @ObservedObject var editorVM: PhotoEditorViewModel
    @ObservedObject var drawingVM: DrawingViewModel

    @State private var canvasSize: CGSize = .zero

    var body: some View {
        GeometryReader { fullGeometry in
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Button("Cancel") {
                        drawingVM.resetDrawingHistory()
                        editorVM.isDrawing = false
                    }
                    .frame(width: 120, alignment: .leading)

                    Spacer()

                    Text("Markup")
                        .font(.headline)

                    Spacer()

                    HStack(spacing: 12) {
                        UndoRedoButtons(
                            canUndo: editorVM.drawingVM.canUndoDrawing,
                            canRedo: editorVM.drawingVM.canRedoDrawing,
                            undo: editorVM.drawingVM.undoDrawing,
                            redo: editorVM.drawingVM.redoDrawing
                        )

                        Button("Done") {
                            drawingVM.applyDrawingToImage(
                                baseImage: editorVM.selectedImage,
                                canvasSize: canvasSize,
                                rotationAngle: editorVM.rotationAngle,
                                offset: editorVM.imageOffset,
                                scale: editorVM.imageScale,
                                commit: editorVM.commitChange,
                                setResult: { editorVM.selectedImage = $0; editorVM.isDrawing = false }
                            )                        }
                    }
                    .frame(width: 120, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .frame(height: 50)
                .background(.ultraThinMaterial)

                Divider()

                // MARK: - Drawing Canvas
                GeometryReader { geo in
                    ZStack(alignment: .center) {
                        if let image = editorVM.selectedImage {
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .overlay(
                                        GeometryReader { imageGeo in
                                            DrawingCanvasView(
                                                currentDrawing: editorVM.drawingVM.currentDrawing,
                                                onDrawingChanged: {
                                                    editorVM.drawingVM.pushDrawingToHistory($0)
                                                }
                                            )
                                            .frame(width: imageGeo.size.width, height: imageGeo.size.height)
                                            .id(editorVM.drawingVM.drawingVersion)
                                            .onAppear {
                                                canvasSize = imageGeo.size
                                            }
                                        }
                                    )
                            }
                            .scaleEffect(editorVM.imageScale)
                            .rotationEffect(editorVM.rotationAngle)
                            .offset(editorVM.imageOffset)
                            .clipped()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .clipped()
                }
            }
        }
    }
}
