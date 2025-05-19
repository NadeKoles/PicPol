//
//  EditableImageModel.swift
//  PicPol
//
//  Created by Nadia on 16/05/2025.
//

import UIKit
import PencilKit

struct EditableImage {
    var original: UIImage
    var filtered: UIImage?
    var drawings: [PKDrawing] = [] // позже, для PencilKit
    var textOverlays: [TextOverlay] = []
}
