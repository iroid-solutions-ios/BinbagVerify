//
//  BinbagVerifySwiftUI.swift
//  BinbagVerifyPackage
//
//  SwiftUI support for BinbagVerify SDK
//

import SwiftUI
import UIKit

// MARK: - SwiftUI View Modifier
@available(iOS 14.0, *)
public struct BinbagVerifyModifier: ViewModifier {
    @Binding var isPresented: Bool
    let verificationType: BinbagVerificationType
    let userEmail: String?
    let onResult: (BinbagVerificationResult) -> Void

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                BinbagVerifyView(
                    verificationType: verificationType,
                    userEmail: userEmail,
                    onResult: { result in
                        isPresented = false
                        onResult(result)
                    },
                    onDismiss: {
                        isPresented = false
                    }
                )
                .ignoresSafeArea()
            }
    }
}

// MARK: - SwiftUI View Extension
@available(iOS 14.0, *)
public extension View {

    /// Present BinbagVerify verification flow in SwiftUI
    /// - Parameters:
    ///   - isPresented: Binding to control presentation
    ///   - type: The type of verification flow
    ///   - userEmail: Optional email for reverification
    ///   - onResult: Callback with verification result
    func binbagVerify(
        isPresented: Binding<Bool>,
        type: BinbagVerificationType = .fullVerification,
        userEmail: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void
    ) -> some View {
        modifier(BinbagVerifyModifier(
            isPresented: isPresented,
            verificationType: type,
            userEmail: userEmail,
            onResult: onResult
        ))
    }
}

// MARK: - UIViewControllerRepresentable
@available(iOS 14.0, *)
public struct BinbagVerifyView: UIViewControllerRepresentable {
    let verificationType: BinbagVerificationType
    let userEmail: String?
    let onResult: (BinbagVerificationResult) -> Void
    let onDismiss: () -> Void

    public init(
        verificationType: BinbagVerificationType = .fullVerification,
        userEmail: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.verificationType = verificationType
        self.userEmail = userEmail
        self.onResult = onResult
        self.onDismiss = onDismiss
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        let viewController: UIViewController

        switch verificationType {
        case .fullVerification:
            // Start with Introduction Video screen
            viewController = IntroductionVideoScreen()

        case .documentOnly:
            // IDScanDocumentTypeVC is created programmatically (not in storyboard)
            viewController = IDScanDocumentTypeVC()

        case .reverification:
            // Use programmatic LoginScreen
            let vc = LoginScreen()
            if let email = userEmail {
                vc.loadViewIfNeeded()
                vc.emailTextField.text = email
            }
            viewController = vc
        }

        // Add close button
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: context.coordinator,
            action: #selector(Coordinator.dismiss)
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        context.coordinator.navigationController = navigationController

        return navigationController
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onResult: onResult, onDismiss: onDismiss)
    }

    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "VerifyDocument", bundle: Bundle.module)
    }

    private func getAuthStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: Bundle.module)
    }

    // MARK: - Coordinator
    public class Coordinator: NSObject {
        let onResult: (BinbagVerificationResult) -> Void
        let onDismiss: () -> Void
        weak var navigationController: UINavigationController?

        init(onResult: @escaping (BinbagVerificationResult) -> Void, onDismiss: @escaping () -> Void) {
            self.onResult = onResult
            self.onDismiss = onDismiss
        }

        @objc func dismiss() {
            onDismiss()
            onResult(BinbagVerificationResult(
                isVerified: false,
                documentData: nil,
                error: .userCancelled
            ))
        }
    }
}

// MARK: - Standalone SwiftUI Button
@available(iOS 14.0, *)
public struct BinbagVerifyButton: View {
    let title: String
    let verificationType: BinbagVerificationType
    let userEmail: String?
    let onResult: (BinbagVerificationResult) -> Void

    @State private var isPresented = false

    public init(
        title: String = "Verify Identity",
        verificationType: BinbagVerificationType = .fullVerification,
        userEmail: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void
    ) {
        self.title = title
        self.verificationType = verificationType
        self.userEmail = userEmail
        self.onResult = onResult
    }

    public var body: some View {
        Button(title) {
            isPresented = true
        }
        .binbagVerify(
            isPresented: $isPresented,
            type: verificationType,
            userEmail: userEmail,
            onResult: onResult
        )
    }
}

// MARK: - Observable Verification Manager (For Simple SwiftUI Integration)
@available(iOS 14.0, *)
public class BinbagVerifyManager: ObservableObject {
    public static let shared = BinbagVerifyManager()

    @Published public var isPresented: Bool = false
    @Published public var lastResult: BinbagVerificationResult?

    public var verificationType: BinbagVerificationType = .fullVerification
    public var userEmail: String?

    private var completionHandler: ((BinbagVerificationResult) -> Void)?

    private init() {}

    /// Start verification - call this from anywhere in SwiftUI
    /// Usage: BinbagVerifyManager.shared.start { result in ... }
    public func start(
        type: BinbagVerificationType = .fullVerification,
        userEmail: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        self.verificationType = type
        self.userEmail = userEmail
        self.completionHandler = completion
        self.isPresented = true
    }

    /// Called when verification completes
    internal func complete(with result: BinbagVerificationResult) {
        self.lastResult = result
        self.isPresented = false
        self.completionHandler?(result)
        self.completionHandler = nil
    }
}

// MARK: - Auto-Presenting View Modifier (Attach Once to Root View)
@available(iOS 14.0, *)
public struct BinbagVerifyAutoPresenter: ViewModifier {
    @ObservedObject private var manager = BinbagVerifyManager.shared

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $manager.isPresented) {
                BinbagVerifyView(
                    verificationType: manager.verificationType,
                    userEmail: manager.userEmail,
                    onResult: { result in
                        manager.complete(with: result)
                    },
                    onDismiss: {
                        manager.complete(with: BinbagVerificationResult(
                            isVerified: false,
                            documentData: nil,
                            error: .userCancelled
                        ))
                    }
                )
                .ignoresSafeArea()
            }
    }
}

// MARK: - Simple View Extension
@available(iOS 14.0, *)
public extension View {

    /// Attach this modifier ONCE to your root view to enable BinbagVerifyManager.shared.start()
    /// Usage:
    /// ```
    /// @main
    /// struct MyApp: App {
    ///     init() {
    ///         BinbagVerify.configure(with: BinbagVerifyConfig(apiKey: "YOUR_KEY"))
    ///     }
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .binbagVerifyEnabled()  // Add this once
    ///         }
    ///     }
    /// }
    /// ```
    /// Then from anywhere: BinbagVerifyManager.shared.start { result in ... }
    func binbagVerifyEnabled() -> some View {
        modifier(BinbagVerifyAutoPresenter())
    }
}

// MARK: - Complete SwiftUI App Example View
@available(iOS 14.0, *)
public struct BinbagVerifyExampleView: View {
    @State private var verificationStatus: String = "Not verified"

    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            Text("BinbagVerify SDK")
                .font(.title)

            Text(verificationStatus)
                .foregroundColor(.gray)

            Button("Start Verification") {
                BinbagVerifyManager.shared.start { result in
                    if result.isVerified {
                        verificationStatus = "Verified ✓"
                    } else if let error = result.error {
                        verificationStatus = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .binbagVerifyEnabled() // Enable auto-presentation
    }
}

// MARK: - Preview Provider
#if DEBUG
@available(iOS 14.0, *)
struct BinbagVerifyButton_Previews: PreviewProvider {
    static var previews: some View {
        BinbagVerifyButton { result in
            print("Verification result: \(result.isVerified)")
        }
        .padding()
    }
}
#endif
