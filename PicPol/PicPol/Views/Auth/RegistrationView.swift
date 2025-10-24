//
//  RegistrationView.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $authVM.email)
                .keyboardType(.emailAddress)
                .inputStyle()

            SecureField("Password", text: $authVM.password)
                .inputStyle()

            Button(action: {
                authVM.signUp()
            }) {
                Text("Sign Up")
            }
            .primaryButton()
      
            // Модальное окно ошибок
            .errorAlert($authVM.errorMessage)

            Button(action: {
                dismiss()
            }) {
                Text("Back")
            }
            .secondaryButton()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

