//
//  ContentView.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//

import SwiftUI
import CoreData
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            if authVM.isAuthenticated {
                ImageUploadView()
            } else {
                LoginView()
            }
        }
    }
}


