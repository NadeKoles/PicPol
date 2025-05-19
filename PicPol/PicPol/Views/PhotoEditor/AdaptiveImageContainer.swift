//
//  AdaptiveImageContainer.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//


import SwiftUI
import Foundation


struct AdaptiveImageContainer: View {
    // MARK: - Props

    let image: UIImage
    let isDraggable: Bool
    let maxSize: CGSize
    let rotationAngle: Angle
    var onCommit: (() -> Void)? = nil

    @Binding var offset: CGSize
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat

    // MARK: - State
    @State private var lastOffset: CGSize = .zero

    // MARK: - Layout Calculation

    private var fittedSize: CGSize {
        let normalizedAngle = rotationAngle.degrees.truncatingRemainder(dividingBy: 360)
        let absoluteAngle = abs(normalizedAngle)
        let isRotated = absoluteAngle == 90 || absoluteAngle == 270
        
        // Определяем тип изображения
        let aspectRatio = image.size.width / image.size.height
        let isHorizontal = aspectRatio > 1.1       // Ширина > высоты (с запасом)
        let isVertical = aspectRatio < 0.9         // Высота > ширины (с запасом)

        // 1. Обработка горизонтальных изображений
        if isHorizontal {
            if isRotated {
                // Горизонтальное → поворот в вертикальное
                let targetHeight = maxSize.height
                let targetWidth = targetHeight * (image.size.height / image.size.width)
                return CGSize(width: targetWidth, height: targetHeight)
            } else {
                // Горизонтальное без поворота
                let targetWidth = maxSize.width
                let targetHeight = targetWidth * (image.size.height / image.size.width)
                return CGSize(width: targetWidth, height: targetHeight)
            }
        }
        // 2. Обработка вертикальных изображений (идеальное решение из вашего кода)
        else if isVertical {
            let baseImageSize = isRotated
                ? CGSize(width: image.size.height, height: image.size.width)
                : image.size
            
            let containerSize = isRotated
                ? CGSize(width: maxSize.height, height: maxSize.width)
                : maxSize
            
            let imageAspect = baseImageSize.width / baseImageSize.height
            let containerAspect = containerSize.width / containerSize.height
            
            if imageAspect > containerAspect {
                let width = containerSize.width
                let height = width / imageAspect
                return CGSize(width: width, height: height)
            } else {
                let height = containerSize.height
                let width = height * imageAspect
                return CGSize(width: width, height: height)
            }
        }
        // 3. Обработка квадратных изображений
        else {
            // Для квадрата просто вписываем в меньшую сторону контейнера
            let containerMinSide = min(maxSize.width, maxSize.height)
            return CGSize(width: containerMinSide, height: containerMinSide)
        }
    }
    
    func reset() {
        scale = 1.0
        lastScale = 1.0
        offset = .zero
        lastOffset = .zero
    }

    // MARK: - Body

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: fittedSize.width, height: fittedSize.height)
            .scaleEffect(scale)
            .rotationEffect(rotationAngle)
            .offset(offset)
            .gesture(magnificationGesture)
            .simultaneousGesture(isDraggable ? dragGesture : nil)
            .animation(.easeInOut(duration: 0.2), value: scale)
            .animation(.easeInOut(duration: 0.2), value: offset)
    }

    // MARK: - Gestures

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = lastScale * value
                if scale < 0.95 {
                    scale = 1.0
                    lastScale = 1.0
                    offset = .zero
                    lastOffset = .zero
                }
            }
            .onEnded { _ in
                lastScale = scale
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let angle = -rotationAngle.radians
                let dx = value.translation.width
                let dy = value.translation.height

                // Поворачиваем вектор
                let rotatedX = dx * CGFloat(cos(angle)) - dy * CGFloat(sin(angle))
                let rotatedY = dx * CGFloat(sin(angle)) + dy * CGFloat(cos(angle))


                offset = CGSize(
                    width: lastOffset.width + rotatedX,
                    height: lastOffset.height + rotatedY
                )
            }
            .onEnded { _ in
                lastOffset = offset
                onCommit?()
            }
    }

}

extension UIImage {
    func scaled(to size: CGSize) -> UIImage {
        let imageAspect = self.size.width / self.size.height
        let targetAspect = size.width / size.height

        var targetSize: CGSize
        if imageAspect > targetAspect {
            let width = size.width
            let height = width / imageAspect
            targetSize = CGSize(width: width, height: height)
        } else {
            let height = size.height
            let width = height * imageAspect
            targetSize = CGSize(width: width, height: height)
        }

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
