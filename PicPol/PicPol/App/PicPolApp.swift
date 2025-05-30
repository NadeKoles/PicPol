//
//  PicPolApp.swift
//  PicPol
//
//  Created by Nadia on 13/05/2025.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct PhotoEditorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel() // Добавляем здесь
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM) // Передаем в окружение
        }
    }
}
