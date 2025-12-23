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
            if let vc = getStoryboard().instantiateViewController(withIdentifier: "SignUpScreen") as? SignUpScreen {
                viewController = vc
            } else {
                viewController = IDScanDocumentTypeVC()
            }

        case .documentOnly:
            if let vc = getStoryboard().instantiateViewController(withIdentifier: "IDScanDocumentTypeVC") as? IDScanDocumentTypeVC {
                viewController = vc
            } else {
                viewController = IDScanDocumentTypeVC()
            }

        case .reverification:
            if let vc = getStoryboard().instantiateViewController(withIdentifier: "LoginScreen") as? LoginScreen {
                if let email = userEmail {
                    vc.loadViewIfNeeded()
                    vc.emailTextField?.text = email
                }
                viewController = vc
            } else {
                let faceStep = IDScanStep(title: "Face")
                let captureVC = IDCaptureVC(documentType: .driversLicenseOrIDCard, stepIndex: 0, step: faceStep)
                captureVC.isFaceOnlyMode = true
                viewController = captureVC
            }
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
        return UIStoryboard(name: "VerifyAccount", bundle: Bundle.module)
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
