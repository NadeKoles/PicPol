//
//  EditorOverlayHeaderView.swift
//  PicPol
//
//  Created by Nadia on 18/05/2025.
//

import SwiftUI

struct EditorOverlayHeaderView: View {
    let title: String
    let canUndo: Bool
    let canRedo: Bool
    let onUndo: () -> Void
    let onRedo: () -> Void
    let onCancel: () -> Void
    let onDone: () -> Void

    var body: some View {
        HStack {
            Button("Cancel", action: onCancel)

            Spacer()

            HStack(spacing: 12) {
                if canUndo || canRedo {
                    Button(action: onUndo) {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .disabled(!canUndo)

                    Button(action: onRedo) {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    .disabled(!canRedo)
                }

                Button("Done", action: onDone)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .frame(height: 50)
        .background(.ultraThinMaterial)
        .overlay(
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.top, 8),
            alignment: .center
        )
    }
}
