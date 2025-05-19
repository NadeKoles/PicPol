//
//  ViewModifiers.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//

import SwiftUI

struct InputFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?

    func body(content: Content) -> some View {
        content
            .alert(isPresented: Binding<Bool>(
                get: { errorMessage != nil },
                set: { _ in errorMessage = nil }
            )) {
                Alert(
                    title: Text("Уведомление"),
                    message: Text(errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
    }
}

extension View {
    
    func inputStyle() -> some View {
        self.modifier(InputFieldModifier())
    }
    
    func errorAlert(_ error: Binding<String?>) -> some View {
        self.modifier(ErrorAlertModifier(errorMessage: error))
    }
    
    func primaryButton() -> some View {
        self.modifier(PrimaryButtonModifier())
    }

    func secondaryButton() -> some View {
        self.modifier(SecondaryButtonModifier())
    }
    
}


