//
//  UndoRedoButtons.swift
//  PicPol
//
//  Created by Nadia on 17/05/2025.
//

import SwiftUI

struct UndoRedoButtons: View {
    let canUndo: Bool
    let canRedo: Bool
    let undo: () -> Void
    let redo: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: undo) {
                Image(systemName: "arrow.uturn.backward")
            }
            .disabled(!canUndo)

            Button(action: redo) {
                Image(systemName: "arrow.uturn.forward")
            }
            .disabled(!canRedo)
        }
    }
}
