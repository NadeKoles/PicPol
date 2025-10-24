//
//  LoginView.swift
//  PicPol
//
//  Created by Nadia on 19/05/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to PicPol")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            TextField("Email", text: $authVM.email)
                .keyboardType(.emailAddress)
                .inputStyle()

            ZStack(alignment: .trailing) {
                Group {
                    if authVM.isPasswordVisible {
                        TextField("Password", text: $authVM.password)
                    } else {
                        SecureField("Password", text: $authVM.password)
                    }
                }
                .inputStyle()
                
                Button(action: {
                    authVM.isPasswordVisible.toggle()
                }) {
                    Image(systemName: authVM.isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }

            Button("Forgot password?") {
                authVM.resetPassword()
            }
            .font(.footnote)
            .foregroundColor(.gray)

            Button("Sign In") {
                authVM.signIn()
            }
            .primaryButton()

            Button("Sign in with Google") {
                authVM.signInWithGoogle()
            }
            .secondaryButton()

            NavigationLink("Sign Up") {
                RegistrationView()
            }
            .font(.footnote)
            .padding(.top, 8)

            // Модальное окно ошибок
            .errorAlert($authVM.errorMessage)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
