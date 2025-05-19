//
//  PhotoEditorView.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//

import SwiftUI
import PhotosUI
import PencilKit
import UIKit

struct PhotoEditorView: View {
    // MARK: - External
    let preloadedImage: UIImage?
    
    // MARK: - State
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel

    @ObservedObject var editorVM = PhotoEditorViewModel()

    @StateObject private var filterVM = FilterViewModel()
    @StateObject var textVM = TextOverlayViewModel()
    @State private var showTextEditor = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var isFirstAppear = true

    
    // MARK: - Init
    init(preloadedImage: UIImage? = nil) {
        self.preloadedImage = preloadedImage
        _editorVM = ObservedObject(wrappedValue: PhotoEditorViewModel())
        _filterVM = StateObject(wrappedValue: FilterViewModel())
        _textVM = StateObject(wrappedValue: TextOverlayViewModel())
        _selectedItem = State(initialValue: nil)
        _showTextEditor = State(initialValue: false)
    }

    
    private func saveToPhotos() {
        guard let image = editorVM.selectedImage else { return }
        let saver = ImageSaver()
        saver.save(image)
    }
    
    
    var body: some View {
            VStack(spacing: 0) {
                // MARK: - Image Editing Area

                GeometryReader { geometry in
                    if let image = editorVM.selectedImage {
                        let size = calculateWorkingArea(in: geometry)
                        ImageEditorAreaView(image: image, usableSize: size, editorVM: editorVM, textVM: textVM)
                    } else if selectedItem != nil {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Text("No image")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                Divider()

                // MARK: - Toolbar
                EditorToolbarView(
                    editorVM: editorVM,
                    filterVM: filterVM,
                    textVM: textVM,
                    onTextTapped: {
                        showTextEditor = true
                    }
                )
            }
            .background(AppColors.background)
            .navigationTitle("Picture Polish")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)

           
            // MARK: - Image Picker
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        editorVM.resetHistory(with: uiImage)
                        filterVM.setOriginalImage(uiImage)
                        editorVM.drawingVM.drawing = PKDrawing()
                    }
                }
            }
            // MARK: - First Launch Image Injection
            .onAppear {
                if isFirstAppear {
                    isFirstAppear = false
                    if let image = preloadedImage {
                        editorVM.resetHistory(with: image)
                        filterVM.setOriginalImage(image)
                    }
                }
            }
        
            // MARK: - Navigation & Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                        Text("Back")

                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 8) {
                        UndoRedoButtons(
                            canUndo: editorVM.canUndo,
                            canRedo: editorVM.canRedo,
                            undo: editorVM.undo,
                            redo: editorVM.redo
                        )

                        Menu {
                            Button {
                                saveToPhotos()
                            } label: {
                                Label("Save to gallery", systemImage: "square.and.arrow.down")
                            }

                            Button {
                                // пока ничего
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }

                    }
                }
            }
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .tint(AppColors.darkTint)
            .ignoresSafeArea(.keyboard)
            .fullScreenCover(isPresented: $editorVM.isDrawing) {
                DrawingOverlayView(editorVM: editorVM, drawingVM: editorVM.drawingVM)
            }
            .fullScreenCover(isPresented: $showTextEditor) {
                if let image = editorVM.selectedImage {
                    TextOverlayFullScreenView(viewModel: textVM, editorVM: editorVM, backgroundImage: image)
                }
            }
        }
    

    // MARK: - Layout Helpers

    private func calculateWorkingArea(in geometry: GeometryProxy) -> CGSize {
        let fullWidth = geometry.size.width
        let usableHeight = geometry.size.height - 80
        return CGSize(width: fullWidth, height: max(usableHeight, 100))
    }
}


