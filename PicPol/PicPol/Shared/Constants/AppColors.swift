//
//  AppColors.swift
//  PicPol
//
//  Created by Nadia on 14/05/2025.
//

import SwiftUI

enum AppColors {
    static let background = Color(hex: "#F6F6F6")          // нейтральный фон
    static let toolbar = Color(hex: "#F2F2F7")             // нижняя панель (как systemGray6)
    static let accent = Color(hex: "#007AFF")              // синий акцент (по умолчанию)
    static let darkTint = Color(hex: "#1C1C1E")            // глубокий тёмный графит
    static let placeholder = Color.gray.opacity(0.5)       // для "нет изображения"
}


// MARK: - HEX → Color (SwiftUI)

extension Color {
    init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(.sRGB, red: r, green: g, blue: b, opacity: Double(alpha))
    }
}

// MARK: - HEX → UIColor

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8) & 0xFF) / 255
        let b = CGFloat(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
