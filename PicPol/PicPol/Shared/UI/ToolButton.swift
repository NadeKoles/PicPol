//
//  ToolButton.swift
//  PicPol
//
//  Created by Nadia on 16/05/2025.
//

import SwiftUI

struct ToolButton: View {
    // MARK: - Props

    let systemName: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .medium))
                .padding(12)
                .background(isActive ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(Circle())
        }
        .foregroundColor(isActive ? .blue : .primary)
    }
}
