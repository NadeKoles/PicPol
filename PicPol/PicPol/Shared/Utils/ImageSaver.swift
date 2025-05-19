//
//  ImageSaver.swift
//  PicPol
//
//  Created by Nadia on 19/05/2025.
//

import UIKit

class ImageSaver: NSObject {
    func save(_ image: UIImage) {
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
        if let error = error {
            print("❌ Save error:", error.localizedDescription)
        } else {
            print("✅ Saved to gallery!")
        }
    }
}
