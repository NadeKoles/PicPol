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
                // MARK: - Header Controls
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

                // MARK: - Image + Drawing Area (synced transforms)
                GeometryReader { geo in
                    ZStack {
                        if let image = editorVM.selectedImage {
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()

                                DrawingCanvasView(
                                    currentDrawing: editorVM.drawingVM.currentDrawing,
                                    onDrawingChanged: {
                                        editorVM.drawingVM.pushDrawingToHistory($0)
                                    }
                                )
                                .id(editorVM.drawingVM.drawingVersion)
                            }
                            .scaleEffect(editorVM.imageScale)
                            .rotationEffect(editorVM.rotationAngle)
                            .offset(editorVM.imageOffset)
                            .background(GeometryReader { innerGeo in
                                Color.clear.onAppear {
                                    canvasSize = innerGeo.size
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
