//
//  DrawingCanvasView.swift
//  PicPol
//
//  Created by Nadia on 16/05/2025.
//

import SwiftUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    
    let currentDrawing: PKDrawing
    let onDrawingChanged: (PKDrawing) -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.delegate = context.coordinator
        
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing.dataRepresentation() != currentDrawing.dataRepresentation() {
            uiView.drawing = currentDrawing
        }
        
        // Настройка инструмента рисования каждый раз при обновлении
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let toolPicker = PKToolPicker.shared(for: window)
                toolPicker?.setVisible(true, forFirstResponder: uiView)
                toolPicker?.addObserver(uiView)
                uiView.becomeFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDrawingChanged: onDrawingChanged)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        weak var canvasView: PKCanvasView?
        let onDrawingChanged: (PKDrawing) -> Void

        init(onDrawingChanged: @escaping (PKDrawing) -> Void) {
            self.onDrawingChanged = onDrawingChanged
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            onDrawingChanged(canvasView.drawing)
        }
    }
}
