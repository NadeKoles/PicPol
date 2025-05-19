//
//  ImageUploadView.swift
//  PicPol
//
//  Created by Nadia on 19/05/2025.
//

import SwiftUI
import PhotosUI

struct ImageUploadView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage? = nil
    @State private var shouldNavigate = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.6))
            
            Button {
                showImagePicker = true
            } label: {
                Label("Add Image", systemImage: "plus")
                    .font(.title2)
                    .padding()
                    .background(Capsule().strokeBorder())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) {
            guard let item = selectedItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    shouldNavigate = true
                }
            }
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            if let image = selectedImage {
                PhotoEditorView(preloadedImage: image)
            }
        }
        .navigationTitle("Upload")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    authVM.signOut()
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Log out")
                }
            }
        }
    }
}

