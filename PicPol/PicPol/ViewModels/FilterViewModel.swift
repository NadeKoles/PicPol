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
    private var baseImage: UIImage?  // Stores the truly original image (never modified)
    private var currentFilterIndex = 0

    private let filters: [CIFilter] = [
        CIFilter.sepiaTone(),
        CIFilter.photoEffectNoir(),
        CIFilter.photoEffectChrome(),
        CIFilter.photoEffectFade()
    ]

    private let context = CIContext()

    func setOriginalImage(_ image: UIImage) {
        // Only reset if we don't have an original yet
        if originalImage == nil {
            originalImage = image
            baseImage = image  // Store the truly original image
            filteredImage = image
            currentFilterIndex = 0  // Start at 0 so first tap goes to 1 (Sepia)
            shouldApplyFilter = false
        }
    }
    
    func updateOriginalImage(_ image: UIImage) {
        // Update the original image without resetting filter index
        // This is used when text or drawings are baked into the image
        originalImage = image
        
        // Re-apply current filter if one is active
        if currentFilterIndex == 0 {
            filteredImage = image
        } else {
            // Re-apply the current filter to the new original image
            guard let cgImage = image.cgImage else { return }
            let ciImage = CIImage(cgImage: cgImage)
            
            let filter: CIFilter
            switch currentFilterIndex {
            case 1: filter = CIFilter.sepiaTone()
            case 2: filter = CIFilter.photoEffectNoir()
            case 3: filter = CIFilter.photoEffectChrome()
            case 4: filter = CIFilter.photoEffectFade()
            default: filter = CIFilter.sepiaTone()
            }
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            if let outputImage = filter.outputImage,
               let cgResult = context.createCGImage(outputImage, from: outputImage.extent) {
                self.filteredImage = UIImage(cgImage: cgResult)
            }
        }
    }

    func cycleFilter() {
        guard let originalImage = originalImage else { return }
        
        // Cycle to next filter (0 = original, 1-4 = filters)
        currentFilterIndex += 1
        if currentFilterIndex >= (filters.count + 1) {
            currentFilterIndex = 0
        }
        
        // If index is 0, return original image
        if currentFilterIndex == 0 {
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
        case 2:
            filter = CIFilter.photoEffectNoir()
        case 3:
            filter = CIFilter.photoEffectChrome()
        case 4:
            filter = CIFilter.photoEffectFade()
        default:
            filter = CIFilter.sepiaTone()
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
    
    func reset() {
        // Reset to the truly original image (before any text or modifications)
        originalImage = baseImage
        filteredImage = baseImage
        currentFilterIndex = 0
        shouldApplyFilter = false
    }
    
    // Public getter for the base image
    var originalBaseImage: UIImage? {
        return baseImage
    }
}
