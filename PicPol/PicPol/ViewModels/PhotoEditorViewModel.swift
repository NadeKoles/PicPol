//
//  PhotoEditorViewModel.swift
//  PicPol
//
//  Created by Nadia on 16/05/2025.
//

import SwiftUI
import Combine
import PencilKit

class PhotoEditorViewModel: ObservableObject {

    // MARK: - Published Properties (UI State)

    @Published var selectedImage: UIImage?
    @Published var rotationAngle: Angle = .zero
    @Published var isDragging: Bool = false
    @Published var imageOffset: CGSize = .zero
    @Published var imageScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var drawingVM = DrawingViewModel()
    @Published var isDrawing: Bool = false
    @Published var undoRedoState: Bool = false


    // MARK: - Image Transformation History

    private struct EditorState: Equatable {
        let image: UIImage
        let angle: Angle
        let offset: CGSize
        let scale: CGFloat

        static func == (lhs: EditorState, rhs: EditorState) -> Bool {
            lhs.image.pngData() == rhs.image.pngData() &&
            lhs.angle == rhs.angle &&
            lhs.offset == rhs.offset &&
            lhs.scale == rhs.scale
        }
    }

    private var history: [EditorState] = []
    private var redoStack: [EditorState] = []

    var canUndo: Bool {
        history.count > 1
    }

    var canRedo: Bool {
        !redoStack.isEmpty
    }

    func commitChange() {
        guard let image = selectedImage else { return }
        let state = EditorState(
            image: image,
            angle: rotationAngle,
            offset: imageOffset,
            scale: imageScale
        )
        guard history.last != state else { return }
        history.append(state)
        redoStack.removeAll()
        DispatchQueue.main.async {
            self.undoRedoState.toggle() // Force immediate UI update
        }
    }

    func undo() {
        guard history.count > 1 else { 
            return 
        }
        let last = history.removeLast()
        redoStack.append(last)
        if let previous = history.last {
            rotationAngle = previous.angle
            imageOffset = previous.offset
            imageScale = previous.scale
            lastScale = previous.scale
            selectedImage = previous.image
            DispatchQueue.main.async {
                self.undoRedoState.toggle() // Force immediate UI update
            }
        }
    }

    func redo() {
        guard let next = redoStack.popLast() else { return }
        history.append(next)
        selectedImage = next.image
        rotationAngle = next.angle
        imageOffset = next.offset
        imageScale = next.scale
        lastScale = next.scale
    }

    func resetTransformations() {
        rotationAngle = .zero
        imageOffset = .zero
        imageScale = 1.0
        lastScale = 1.0
        commitChange()
    }

    func resetHistory(with image: UIImage) {
        history.removeAll()
        redoStack.removeAll()
        rotationAngle = .zero
        imageOffset = .zero
        imageScale = 1.0
        lastScale = 1.0
        selectedImage = image

        history.append(EditorState(
            image: image,
            angle: .zero,
            offset: .zero,
            scale: 1.0
        ))
    }

 

    func applyText(from textVM: TextOverlayViewModel) {
        guard let baseImage = selectedImage else { return }
        let result = textVM.renderText(on: baseImage)
        selectedImage = result
        commitChange()
    }
}


extension UIColor {
    convenience init(from color: Color) {
        switch color {
        case Color.white: self.init(white: 1, alpha: 1)
        case Color.black: self.init(white: 0, alpha: 1)
        case Color.red: self.init(red: 1, green: 0, blue: 0, alpha: 1)
        case Color.blue: self.init(red: 0, green: 0, blue: 1, alpha: 1)
        case Color.green: self.init(red: 0, green: 1, blue: 0, alpha: 1)
        case Color.yellow: self.init(red: 1, green: 1, blue: 0, alpha: 1)
        default: self.init(white: 1, alpha: 1)
        }
    }
}
