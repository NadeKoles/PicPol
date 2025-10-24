//
//  ImageSaver.swift
//  PicPol
//
//  Created by Nadia on 19/05/2025.
//

import UIKit
import Photos

class ImageSaver: NSObject {
    
    // MARK: - Completion Handler
    typealias SaveCompletion = (Result<Void, ImageSaveError>) -> Void
    
    // MARK: - Properties
    private var completion: SaveCompletion?
    
    // MARK: - Public Methods
    
    func save(_ image: UIImage, completion: @escaping SaveCompletion) {
        self.completion = completion
        
        // Check photo library permission
        checkPhotoLibraryPermission { [weak self] hasPermission in
            guard let self = self else { return }
            
            if hasPermission {
                self.performSave(image)
            } else {
                DispatchQueue.main.async {
                    self.completion?(.failure(.permissionDenied))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    private func performSave(_ image: UIImage) {
        DispatchQueue.main.async {
            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(self.saveCompleted),
                nil
            )
        }
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                let saveError = ImageSaveError.from(error)
                self.completion?(.failure(saveError))
            } else {
                self.completion?(.success(()))
            }
            self.completion = nil // Clean up
        }
    }
}

// MARK: - Error Types

enum ImageSaveError: LocalizedError {
    case permissionDenied
    case saveFailed(String)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Photo library access denied. Please enable access in Settings."
        case .saveFailed(let message):
            return "Failed to save image: \(message)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    static func from(_ error: Error) -> ImageSaveError {
        if let nsError = error as NSError? {
            // Check for common photo library error codes
            switch nsError.code {
            case -3310: // PHPhotosError.accessUserDenied
                return .permissionDenied
            case -3311: // PHPhotosError.accessRestricted  
                return .permissionDenied
            case -3312: // PHPhotosError.userCancelled
                return .saveFailed("User cancelled the save operation")
            default:
                return .saveFailed(nsError.localizedDescription)
            }
        }
        return .unknown(error)
    }
}
