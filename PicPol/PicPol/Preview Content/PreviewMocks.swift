////
////  PreviewMocks.swift
////  PicPol
////
////  Created by Nadia on 19/05/2025.
////
//
//import SwiftUI
//import Combine
//
//// MARK: - Мок изображения
//extension UIImage {
//    static var mock: UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 200))
//        return renderer.image { ctx in
//            UIColor.systemTeal.setFill()
//            ctx.fill(CGRect(x: 0, y: 0, width: 300, height: 200))
//        }
//    }
//}
//
//// MARK: - Мок авторизации
//@MainActor
//class MockAuthViewModel: AuthViewModel {
//    private let mockedStatus: Bool
//
//    init(isAuthenticated: Bool) {
//        self.mockedStatus = isAuthenticated
//        super.init()
//    }
//
//    override var isAuthenticated: Bool {
//        mockedStatus
//    }
//
//    override func signIn() {}
//    override func signInWithGoogle() {}
//    override func signUp() {}
//    override func resetPassword() {}
//    override func signOut() {}
//}
//
//// MARK: - Превью ContentView
//#Preview("ContentView (вошел)") {
//    ContentView()
//        .environmentObject(MockAuthViewModel(isAuthenticated: true))
//}
//
//#Preview("ContentView (не вошел)") {
//    ContentView()
//        .environmentObject(MockAuthViewModel(isAuthenticated: false))
//}
//
//// MARK: - Превью LoginView
//#Preview("LoginView") {
//    LoginView()
//        .environmentObject(MockAuthViewModel(isAuthenticated: false))
//}
//
//// MARK: - Превью ImageUploadView
//#Preview("ImageUploadView") {
//    NavigationStack {
//        ImageUploadView()
//    }
//    .environmentObject(MockAuthViewModel(isAuthenticated: true))
//}
//
//// MARK: - Превью PhotoEditorView
//#Preview("PhotoEditorView") {
//    PhotoEditorView(preloadedImage: .mock)
//        .environmentObject(MockAuthViewModel(isAuthenticated: true))
//}
//
//// MARK: - Превью полного цикла (мок)
//struct FullMockedFlowPreview: View {
//    @StateObject var authVM = MockAuthViewModel(isAuthenticated: true)
//
//    var body: some View {
//        NavigationStack {
//            PhotoEditorView(preloadedImage: .mock)
//        }
//        .environmentObject(authVM)
//    }
//}
//
//#Preview("Full Editor Flow") {
//    FullMockedFlowPreview()
//}
