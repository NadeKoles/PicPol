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
    @Published var shouldApplyFilter = false

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
        // Only reset if we don't have an original yet or if image changed
        if originalImage == nil {
            originalImage = image
            filteredImage = image
            currentFilterIndex = 0  // Start at 0 so first tap goes to 1 (Sepia)
            shouldApplyFilter = false
        }
    }

    func cycleFilter() {
        guard let originalImage = originalImage else { return }
        
        // Cycle to next filter (0 = original, 1-4 = filters)
        currentFilterIndex += 1
        if currentFilterIndex >= (filters.count + 1) {
            currentFilterIndex = 0
        }
        
        print("🔍 Filter tap - index: \(currentFilterIndex)")
        
        // If index is 0, return original image
        if currentFilterIndex == 0 {
            print("   → Showing: Original")
            self.filteredImage = originalImage
            return
        }
        
        // Apply the filter to the original image
        guard let cgImage = originalImage.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Create a fresh filter instance
        let filter: CIFilter
        switch currentFilterIndex {
        case 1:
            filter = CIFilter.sepiaTone()
            print("   → Showing: Sepia")
        case 2:
            filter = CIFilter.photoEffectNoir()
            print("   → Showing: Noir (B&W)")
        case 3:
            filter = CIFilter.photoEffectChrome()
            print("   → Showing: Chrome")
        case 4:
            filter = CIFilter.photoEffectFade()
            print("   → Showing: Fade")
        default:
            filter = CIFilter.sepiaTone()
            print("   → Showing: Sepia (default)")
        }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        if let outputImage = filter.outputImage,
           let cgResult = context.createCGImage(outputImage, from: outputImage.extent) {
            self.filteredImage = UIImage(cgImage: cgResult)
        }
    }

    func applyCurrentFilter() {
        shouldApplyFilter = true
    }
}
