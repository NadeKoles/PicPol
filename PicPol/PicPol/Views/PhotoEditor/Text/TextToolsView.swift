//
//  TextToolsView.swift
//  PicPol
//
//  Created by Nadia on 18/05/2025.
//

import SwiftUI

struct TextToolsView: View {
    @ObservedObject var viewModel: TextOverlayViewModel

    let availableFonts = [
        "Arial", "Helvetica Neue", "Georgia", "Courier New", "Times New Roman"
    ]
    
    let availableColors: [(name: String, hex: String)] = [
        ("White", "#FFFFFF"),
        ("Black", "#000000"),
        ("Red", "#FF3B30"),
        ("Blue", "#007AFF"),
        ("Green", "#34C759"),
        ("Yellow", "#FFD60A")
    ]

    var body: some View {
        VStack(spacing: 16) {

            // MARK: - Font Size Slider
            HStack {
                Text("Size")
                    .font(.caption)
                Slider(
                    value: Binding(
                        get: { viewModel.textOverlay?.fontSize ?? 32 },
                        set: { viewModel.textOverlay?.fontSize = $0 }
                    ),
                    in: 12...72
                )
            }
            .padding(.horizontal)

            // MARK: - Font Picker
            HStack {
                Text("Font")
                    .font(.caption)
                Spacer()
                Picker("Font", selection: Binding(
                    get: { viewModel.textOverlay?.fontName ?? "Arial" },
                    set: { viewModel.textOverlay?.fontName = $0 }
                )) {
                    ForEach(availableFonts, id: \.self) { font in
                        Text(font).font(.custom(font, size: 16)).tag(font)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
            
            // MARK: - Color Picker (Hex-based)
            HStack(spacing: 16) {
                ForEach(availableColors, id: \.hex) { colorOption in
                    let isSelected = viewModel.textOverlay?.colorHex == colorOption.hex
                    Circle()
                        .fill(Color(hex: colorOption.hex))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.accentColor : .gray.opacity(0.5), lineWidth: 2)
                        )
                        .onTapGesture {
                            viewModel.textOverlay?.colorHex = colorOption.hex
                        }
                }
            }
            
            // MARK: - Alpha Slider (optional)
            HStack {
                Text("Opacity")
                    .font(.caption)
                Slider(
                    value: Binding(
                        get: { viewModel.textOverlay?.alpha ?? 1.0 },
                        set: { viewModel.textOverlay?.alpha = $0 }
                    ),
                    in: 0.1...1.0
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding(.bottom, 8)
    }
}
