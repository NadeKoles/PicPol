//
//  TextOverlayViewModel.swift
//  PicPol
//
//  Created by Nadia on 18/05/2025.
//

import SwiftUI

// MARK: - Text Overlay Data Model

struct TextOverlay: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var position: CGSize = .zero
    var color: Color = .white
    var fontSize: CGFloat = 32
    var fontName: String = "Arial"
    var colorHex: String = "#FFFFFF"
    var alpha: CGFloat = 1.0
}

// MARK: - ViewModel for Text Overlay

class TextOverlayViewModel: ObservableObject {
    @Published var isAddingText: Bool = false
    @Published var textOverlay: TextOverlay? = nil

    func reset() {
        isAddingText = false
        textOverlay = nil
    }
    
    func updateText(_ newText: String) {
        guard textOverlay != nil else { return }
        textOverlay?.text = newText
    }
    
    func updatePosition(_ newPosition: CGSize) {
        guard textOverlay != nil else { return }
        textOverlay?.position = newPosition
    }
    
    func renderText(on image: UIImage) -> UIImage {
         guard let overlay = textOverlay else { return image }

         let imageSize = image.size
         let scale = image.scale

         UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
         image.draw(in: CGRect(origin: .zero, size: imageSize))

         let context = UIGraphicsGetCurrentContext()
         context?.saveGState()
         context?.setAllowsAntialiasing(true)
         context?.setShouldAntialias(true)
         context?.interpolationQuality = .high

         let screenWidth = UIScreen.main.bounds.width
         let scaleFactor = imageSize.width / screenWidth
         let adjustedFontSize = overlay.fontSize * scaleFactor

         let font = UIFont(name: overlay.fontName, size: adjustedFontSize)
             ?? UIFont.systemFont(ofSize: adjustedFontSize)

         let attributes: [NSAttributedString.Key: Any] = [
             .font: font,
             .foregroundColor: UIColor(hex: overlay.colorHex, alpha: overlay.alpha)
         ]

         let text = overlay.text as NSString
         let textSize = text.size(withAttributes: attributes)

         let center = CGPoint(
             x: imageSize.width / 2 + overlay.position.width * scaleFactor,
             y: imageSize.height / 2 + overlay.position.height * scaleFactor
         )

         let textRect = CGRect(
             origin: CGPoint(x: center.x - textSize.width / 2,
                             y: center.y - textSize.height / 2),
             size: textSize
         )

         text.draw(in: textRect, withAttributes: attributes)

         context?.restoreGState()

         let finalImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return finalImage ?? image
     }

}

