//
//  AuthViewModel.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//

import Foundation
import Combine
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import SwiftUICore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isPasswordVisible = false
    
    var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
    
    //MARK: - Вход через email и пароль
    
    func signIn() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email"
            return
        }

        guard isValidPassword(password) else {
            errorMessage = "Password must be at least 6 characters"
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.errorMessage = "Invalid email or password"
                } else {
                    self?.objectWillChange.send()
                }
            }
        }
    }
    
    //MARK: - Вход через Google
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                if (error as NSError).code != GIDSignInError.canceled.rawValue {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                self?.errorMessage = "Failed to get Google token"
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        self?.objectWillChange.send()
                    }
                }
            }
        }
    }



    //MARK: - Регистрация через email и пароль
    
    func signUp() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email"
            return
        }

        guard isValidPassword(password) else {
            errorMessage = "Password must be at least 6 characters"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        self?.errorMessage = "This email is already registered"
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                    return
                }

                result?.user.sendEmailVerification(completion: nil)
                self?.errorMessage = "Confirmation email has been sent"
                self?.objectWillChange.send()
            }
        }
    }

   
    //MARK: - Сброс пароля
    
    func resetPassword() {
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format"
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.errorMessage = "Password reset link has been sent to your email"
                }
            }
        }
    }

    //MARK: - Проверка валидности email и пароля
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    //MARK: - Выйти из аккаунта
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            objectWillChange.send()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}


