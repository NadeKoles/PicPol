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
        
        // Set up tool picker immediately
        DispatchQueue.main.async {
            self.setupToolPickerImmediately(for: canvasView)
        }
        
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing.dataRepresentation() != currentDrawing.dataRepresentation() {
            uiView.drawing = currentDrawing
        }
        
        // Ensure tool picker is visible when drawing mode is active
        DispatchQueue.main.async {
            self.setupToolPicker(for: uiView)
        }
    }
    
    private func setupToolPickerImmediately(for canvasView: PKCanvasView) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let windows = windowScene.windows.sorted { $0.windowLevel > $1.windowLevel }
            if let window = windows.first {
                let toolPicker = PKToolPicker.shared(for: window)
                
                // Force the canvas to become first responder first
                canvasView.becomeFirstResponder()
                
                // Set up the tool picker
                toolPicker?.addObserver(canvasView)
                toolPicker?.setVisible(true, forFirstResponder: canvasView)
                
                // Force visibility with multiple attempts
                DispatchQueue.main.async {
                    toolPicker?.setVisible(true, forFirstResponder: canvasView)
                    canvasView.becomeFirstResponder()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    toolPicker?.setVisible(true, forFirstResponder: canvasView)
                    canvasView.becomeFirstResponder()
                }
            }
        }
    }
    
    private func setupToolPicker(for canvasView: PKCanvasView) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let windows = windowScene.windows.sorted { $0.windowLevel > $1.windowLevel }
            if let window = windows.first {
                let toolPicker = PKToolPicker.shared(for: window)
                toolPicker?.setVisible(true, forFirstResponder: canvasView)
                toolPicker?.addObserver(canvasView)
                canvasView.becomeFirstResponder()
                
                // Multiple aggressive attempts to make it visible
                for i in 1...10 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                        toolPicker?.setVisible(true, forFirstResponder: canvasView)
                        canvasView.becomeFirstResponder()
                        
                        // If it becomes visible, we can stop trying
                        if toolPicker?.isVisible == true {
                            return
                        }
                    }
                }
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

