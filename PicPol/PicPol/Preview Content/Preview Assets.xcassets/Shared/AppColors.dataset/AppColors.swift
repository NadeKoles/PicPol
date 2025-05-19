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


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
