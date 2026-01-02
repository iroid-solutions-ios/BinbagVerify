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
    let email: String?
    let onResult: (BinbagVerificationResult) -> Void

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                BinbagVerifyView(
                    verificationType: verificationType,
                    email: email,
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

    /// Present BinbagVerify document scan flow in SwiftUI
    /// - Parameters:
    ///   - isPresented: Binding to control presentation
    ///   - email: User's email address (optional for document scan)
    ///   - onResult: Callback with verification result
    func binbagDocumentScan(
        isPresented: Binding<Bool>,
        email: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void
    ) -> some View {
        modifier(BinbagVerifyModifier(
            isPresented: isPresented,
            verificationType: .documentScan,
            email: email,
            onResult: onResult
        ))
    }

    /// Present BinbagVerify face detection flow in SwiftUI
    /// - Parameters:
    ///   - isPresented: Binding to control presentation
    ///   - email: User's email address (required for face detection)
    ///   - onResult: Callback with verification result
    func binbagFaceDetection(
        isPresented: Binding<Bool>,
        email: String,
        onResult: @escaping (BinbagVerificationResult) -> Void
    ) -> some View {
        modifier(BinbagVerifyModifier(
            isPresented: isPresented,
            verificationType: .faceDetection,
            email: email,
            onResult: onResult
        ))
    }

    /// Present BinbagVerify verification flow in SwiftUI
    /// - Parameters:
    ///   - isPresented: Binding to control presentation
    ///   - type: The type of verification flow (.documentScan or .faceDetection)
    ///   - email: User's email address (required for faceDetection)
    ///   - onResult: Callback with verification result
    func binbagVerify(
        isPresented: Binding<Bool>,
        type: BinbagVerificationType = .documentScan,
        email: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void
    ) -> some View {
        modifier(BinbagVerifyModifier(
            isPresented: isPresented,
            verificationType: type,
            email: email,
            onResult: onResult
        ))
    }
}

// MARK: - UIViewControllerRepresentable
@available(iOS 14.0, *)
public struct BinbagVerifyView: UIViewControllerRepresentable {
    let verificationType: BinbagVerificationType
    let email: String?
    let onResult: (BinbagVerificationResult) -> Void
    let onDismiss: () -> Void

    public init(
        verificationType: BinbagVerificationType = .documentScan,
        email: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.verificationType = verificationType
        self.email = email
        self.onResult = onResult
        self.onDismiss = onDismiss
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        // Store email in shared instance for this verification session
        BinbagVerify.shared.currentEmail = email

        let viewController: UIViewController

        switch verificationType {
        case .documentScan:
            // Start with IDScanStepsVC directly
            viewController = IDScanStepsVC(documentType: .driversLicenseOrIDCard)

        case .faceDetection:
            // Start with face capture only
            viewController = createFaceOnlyCaptureVC()
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

    private func createFaceOnlyCaptureVC() -> UIViewController {
        let faceStep = IDScanStep(title: "Face")
        let captureVC = IDCaptureVC(documentType: .driversLicenseOrIDCard, stepIndex: 0, step: faceStep)
        captureVC.isFaceOnlyMode = true

        // Set up face capture completion handler
        captureVC.onCaptured = { [weak captureVC] image in
            guard let vc = captureVC else { return }

            // Get email from current verification session
            guard let email = BinbagVerify.shared.currentEmail, !email.isEmpty else {
                BinbagVerify.shared.failVerification(with: .verificationFailed("Email is required for face detection"))
                return
            }

            guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
                BinbagVerify.shared.failVerification(with: .verificationFailed("Failed to capture face image"))
                return
            }

            Utility.showIndicator()
            AuthServices.shared.reverify(email: email, age: "0", livePhotoData: imageData) { statusCode, response in
                Utility.hideIndicator()

                DispatchQueue.main.async {
                    // Dismiss the screen first, then call completion
                    vc.navigationController?.dismiss(animated: true) {
                        if (200..<300).contains(statusCode), let data = response.documentVerificationData {
                            // Success
                            BinbagVerify.shared.completionHandler?(BinbagVerificationResult(
                                isVerified: true,
                                documentData: data,
                                error: nil
                            ))
                        } else {
                            // Failed
                            BinbagVerify.shared.completionHandler?(BinbagVerificationResult(
                                isVerified: false,
                                documentData: response.documentVerificationData,
                                error: .verificationFailed(response.message ?? "Verification failed")
                            ))
                        }
                    }
                }
            } failure: { error in
                Utility.hideIndicator()
                DispatchQueue.main.async {
                    vc.navigationController?.dismiss(animated: true) {
                        BinbagVerify.shared.completionHandler?(BinbagVerificationResult(
                            isVerified: false,
                            documentData: nil,
                            error: .verificationFailed(error)
                        ))
                    }
                }
            }
        }

        return captureVC
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
    let email: String?
    let onResult: (BinbagVerificationResult) -> Void

    @State private var isPresented = false

    public init(
        title: String = "Verify Identity",
        verificationType: BinbagVerificationType = .documentScan,
        email: String? = nil,
        onResult: @escaping (BinbagVerificationResult) -> Void
    ) {
        self.title = title
        self.verificationType = verificationType
        self.email = email
        self.onResult = onResult
    }

    public var body: some View {
        Button(title) {
            isPresented = true
        }
        .binbagVerify(
            isPresented: $isPresented,
            type: verificationType,
            email: email,
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

    public var verificationType: BinbagVerificationType = .documentScan
    public var email: String?

    private var completionHandler: ((BinbagVerificationResult) -> Void)?

    private init() {}

    /// Start document scan flow - call this from anywhere in SwiftUI
    /// Usage: BinbagVerifyManager.shared.startDocumentScan(email: "user@example.com") { result in ... }
    /// - Parameters:
    ///   - email: User's email address (optional for document scan)
    ///   - completion: Completion handler with the result
    public func startDocumentScan(
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        self.verificationType = .documentScan
        self.email = email
        self.completionHandler = completion
        self.isPresented = true
    }

    /// Start face detection flow - call this from anywhere in SwiftUI
    /// Usage: BinbagVerifyManager.shared.startFaceDetection(email: "user@example.com") { result in ... }
    /// - Parameters:
    ///   - email: User's email address (required for face detection)
    ///   - completion: Completion handler with the result
    public func startFaceDetection(
        email: String,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        self.verificationType = .faceDetection
        self.email = email
        self.completionHandler = completion
        self.isPresented = true
    }

    /// Start verification - call this from anywhere in SwiftUI
    /// Usage: BinbagVerifyManager.shared.start(type: .documentScan, email: "user@example.com") { result in ... }
    /// - Parameters:
    ///   - type: The type of verification flow
    ///   - email: User's email address (required for faceDetection)
    ///   - completion: Completion handler with the result
    public func start(
        type: BinbagVerificationType = .documentScan,
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        self.verificationType = type
        self.email = email
        self.completionHandler = completion
        self.isPresented = true
    }

    /// Called when verification completes
    internal func complete(with result: BinbagVerificationResult) {
        self.lastResult = result
        self.isPresented = false
        self.email = nil
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
                    email: manager.email,
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
    @State private var userEmail: String = "user@example.com"

    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            Text("BinbagVerify SDK")
                .font(.title)

            TextField("Email", text: $userEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Text(verificationStatus)
                .foregroundColor(.gray)

            Button("Document Scan") {
                BinbagVerifyManager.shared.startDocumentScan(email: userEmail) { result in
                    if result.isVerified {
                        verificationStatus = "Document Verified"
                    } else if let error = result.error {
                        verificationStatus = "Error: \(error.localizedDescription)"
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Face Detection") {
                BinbagVerifyManager.shared.startFaceDetection(email: userEmail) { result in
                    if result.isVerified {
                        verificationStatus = "Face Verified"
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
