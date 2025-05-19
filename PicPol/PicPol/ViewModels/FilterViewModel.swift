//
//  PhotoFilterViewModel.swift
//  PicPol
//
//  Created by Nadia on 16/05/2025.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class FilterViewModel: ObservableObject {
    @Published var filteredImage: UIImage?

    private var originalImage: UIImage?
    private var currentFilterIndex = 0

    private let filters: [CIFilter] = [
        CIFilter.sepiaTone(),
        CIFilter.photoEffectNoir(),
        CIFilter.photoEffectChrome(),
        CIFilter.photoEffectFade()
    ]

    private let context = CIContext()

    func setOriginalImage(_ image: UIImage) {
        originalImage = image
        filteredImage = image
        currentFilterIndex = 0
    }

    func applyNextFilter() {
        guard let originalImage = originalImage,
              let cgImage = originalImage.cgImage else { return }

        let ciImage = CIImage(cgImage: cgImage)
        let filter = filters[currentFilterIndex % filters.count]
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        if let outputImage = filter.outputImage,
           let cgResult = context.createCGImage(outputImage, from: outputImage.extent) {
            self.filteredImage = UIImage(cgImage: cgResult)
        }

        currentFilterIndex += 1
    }
    
}
