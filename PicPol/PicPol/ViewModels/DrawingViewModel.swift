//
//  DrawingViewModel.swift
//  PicPol
//
//  Created by Nadia on 19/05/2025.
//

// DrawingViewModel.swift

import Foundation
import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    
    @Published var drawing: PKDrawing = PKDrawing()
    @Published var currentDrawing: PKDrawing = PKDrawing()
    @Published var drawingVersion = UUID()
    @Published private(set) var drawingIndex: Int = 0

    private var drawingHistory: [PKDrawing] = [PKDrawing()]

    var canUndoDrawing: Bool {
        drawingIndex > 0
    }

    var canRedoDrawing: Bool {
        drawingIndex < drawingHistory.count - 1
    }

    func pushDrawingToHistory(_ newDrawing: PKDrawing) {
        if newDrawing.bounds.isEmpty {
            return
        }

        if currentDrawing == newDrawing {
            return
        }

        if drawingHistory.indices.contains(drawingIndex),
           drawingHistory[drawingIndex] == newDrawing {
            return
        }

        if drawingIndex < drawingHistory.count - 1 {
            drawingHistory = Array(drawingHistory.prefix(upTo: drawingIndex + 1))
        }

        drawingHistory.append(newDrawing)
        drawingIndex += 1
        currentDrawing = newDrawing
    }

    func undoDrawing() {
        guard drawingIndex > 0 else { return }
        drawingIndex -= 1
        currentDrawing = drawingHistory[drawingIndex]
        forceCanvasSync()
    }

    func redoDrawing() {
        guard drawingIndex < drawingHistory.count - 1 else { return }
        drawingIndex += 1
        currentDrawing = drawingHistory[drawingIndex]
        forceCanvasSync()
    }

    func resetDrawingHistory() {
        drawing = PKDrawing()
        currentDrawing = PKDrawing()
        drawingHistory = [PKDrawing()]
        drawingIndex = 0
        forceCanvasSync()
    }

    func clearDrawing() {
        drawing = PKDrawing()
        currentDrawing = PKDrawing()
        pushDrawingToHistory(currentDrawing)
        forceCanvasSync()
    }

    func applyDrawingToImage(
        baseImage: UIImage?,
        canvasSize: CGSize,
        rotationAngle: Angle,
        offset: CGSize,
        scale: CGFloat,
        commit: () -> Void,
        setResult: (UIImage) -> Void
    ) {
        guard let baseImage else { return }

        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        let combinedImage = renderer.image { context in
            baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))

            let drawingBounds = currentDrawing.bounds
            let scaleX = baseImage.size.width / canvasSize.width
            let scaleY = baseImage.size.height / canvasSize.height

            let translatedOffset = CGSize(
                width: offset.width * scaleX,
                height: offset.height * scaleY
            )

            context.cgContext.saveGState()

            context.cgContext.translateBy(
                x: baseImage.size.width / 2 + translatedOffset.width,
                y: baseImage.size.height / 2 + translatedOffset.height
            )

            context.cgContext.rotate(by: CGFloat(rotationAngle.radians))

            context.cgContext.scaleBy(x: scale * scaleX, y: scale * scaleY)

            context.cgContext.translateBy(
                x: -canvasSize.width / 2,
                y: -canvasSize.height / 2
            )

            let drawingImage = currentDrawing.image(from: drawingBounds, scale: baseImage.scale)
            drawingImage.draw(in: CGRect(origin: .zero, size: canvasSize))

            context.cgContext.restoreGState()
        }

        setResult(combinedImage)
        commit()
        resetDrawingHistory()
    }

    
    func forceCanvasSync() {
        withAnimation(.easeInOut(duration: 0.25)) {
            drawingVersion = UUID()
        }
    }
}
