//
//  BinbagVerify.swift
//  BinbagVerifyPackage
//
//  Main entry point for BinbagVerify SDK
//

import UIKit

// MARK: - SDK Configuration
public struct BinbagVerifyConfig {
    public let apiKey: String
    public let environment: BinbagEnvironment
    public let primaryColor: UIColor

    public init(
        apiKey: String,
        environment: BinbagEnvironment = .production,
        primaryColor: UIColor = .systemBlue
    ) {
        self.apiKey = apiKey
        self.environment = environment
        self.primaryColor = primaryColor
    }
}

public enum BinbagEnvironment {
    case development
    case staging
    case production

    var baseURL: String {
        switch self {
        case .development:
            return "https://dev.iroidsolutions.com:3035/api"
        case .staging:
            return "https://staging.binbag.com/api"
        case .production:
            return "https://api.binbag.com/api"
        }
    }
}

// MARK: - Verification Result
public struct BinbagVerificationResult {
    public let isVerified: Bool
    public let documentData: DocumentVerificationData?
    public let error: BinbagVerifyError?

    public init(isVerified: Bool, documentData: DocumentVerificationData?, error: BinbagVerifyError?) {
        self.isVerified = isVerified
        self.documentData = documentData
        self.error = error
    }
}

public enum BinbagVerifyError: Error, LocalizedError {
    case notConfigured
    case userCancelled
    case verificationFailed(String)
    case networkError(String)
    case cameraAccessDenied
    case invalidDocument

    public var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "BinbagVerify SDK is not configured. Call BinbagVerify.configure() first."
        case .userCancelled:
            return "User cancelled the verification process."
        case .verificationFailed(let message):
            return "Verification failed: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .cameraAccessDenied:
            return "Camera access is required for document verification."
        case .invalidDocument:
            return "The document could not be verified. Please try again."
        }
    }
}

// MARK: - Verification Flow Type
public enum BinbagVerificationType {
    case documentScan          // Document + Face verification
    case faceDetection         // Face only verification (for reverification)
}

// MARK: - Delegate Protocol
public protocol BinbagVerifyDelegate: AnyObject {
    func binbagVerifyDidComplete(result: BinbagVerificationResult)
    func binbagVerifyDidCancel()
}

// MARK: - Main SDK Class
public final class BinbagVerify {

    // MARK: - Singleton
    public static let shared = BinbagVerify()

    // MARK: - Properties
    private var config: BinbagVerifyConfig?
    public weak var delegate: BinbagVerifyDelegate?

    /// Current email for the ongoing verification (set when starting verification)
    internal var currentEmail: String?

    internal var completionHandler: ((BinbagVerificationResult) -> Void)?

    private init() {}

    // MARK: - Configuration

    /// Configure the SDK with your API key, email and settings
    /// Call this in your AppDelegate or App init
    public static func configure(with config: BinbagVerifyConfig) {
        shared.config = config
        // Update APIManager with config
        APIManager.shared.updateConfig(apiKey: config.apiKey, baseURL: config.environment.baseURL)
    }

    /// Get current configuration
    public var currentConfig: BinbagVerifyConfig? {
        return config
    }

    /// Check if SDK is configured
    public var isConfigured: Bool {
        return config != nil
    }

    // MARK: - Simple Start Methods (No ViewController Required)

    /// Start document scan flow - automatically finds top view controller
    /// Usage: BinbagVerify.startDocumentScan(email: "user@example.com") { result in ... }
    /// - Parameters:
    ///   - email: User's email address for verification (required for faceDetection, optional for documentScan)
    ///   - completion: Completion handler with the result
    public static func startDocumentScan(
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        shared.startFromTopViewController(type: .documentScan, email: email, completion: completion)
    }

    /// Start face detection flow - automatically finds top view controller
    /// Usage: BinbagVerify.startFaceDetection(email: "user@example.com") { result in ... }
    /// - Parameters:
    ///   - email: User's email address for reverification (required)
    ///   - completion: Completion handler with the result
    public static func startFaceDetection(
        email: String,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        shared.startFromTopViewController(type: .faceDetection, email: email, completion: completion)
    }

    /// Start verification with specific type - automatically finds top view controller
    /// Usage: BinbagVerify.start(type: .documentScan, email: "user@example.com") { result in ... }
    public static func start(
        type: BinbagVerificationType,
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        shared.startFromTopViewController(type: type, email: email, completion: completion)
    }

    /// Internal method to start from automatically detected top view controller
    private func startFromTopViewController(
        type: BinbagVerificationType,
        email: String?,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        guard let topVC = Self.getTopViewController() else {
            completion(BinbagVerificationResult(
                isVerified: false,
                documentData: nil,
                error: .verificationFailed("Unable to present verification screen")
            ))
            return
        }

        startVerification(from: topVC, type: type, email: email, completion: completion)
    }

    /// Get the top-most view controller in the app
    private static func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootVC = window.rootViewController else {
            return nil
        }

        return getTopViewController(from: rootVC)
    }

    private static func getTopViewController(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return getTopViewController(from: presented)
        }

        if let navigationController = viewController as? UINavigationController,
           let visible = navigationController.visibleViewController {
            return getTopViewController(from: visible)
        }

        if let tabBarController = viewController as? UITabBarController,
           let selected = tabBarController.selectedViewController {
            return getTopViewController(from: selected)
        }

        return viewController
    }

    // MARK: - Start Verification (UIKit)

    /// Start the verification flow from a UIViewController
    /// - Parameters:
    ///   - presentingViewController: The view controller to present from
    ///   - type: The type of verification flow (.documentScan or .faceDetection)
    ///   - email: User's email address (required for faceDetection)
    ///   - completion: Completion handler with the result
    public func startVerification(
        from presentingViewController: UIViewController,
        type: BinbagVerificationType = .documentScan,
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        guard config != nil else {
            completion(BinbagVerificationResult(
                isVerified: false,
                documentData: nil,
                error: .notConfigured
            ))
            return
        }

        // Store email for this verification session
        self.currentEmail = email
        self.completionHandler = completion

        let viewController: UIViewController

        switch type {
        case .documentScan:
            // Start with IDScanStepsVC directly
            viewController = createDocumentScanVC()

        case .faceDetection:
            // Start with face capture only
            viewController = createFaceOnlyCaptureVC()
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen

        // Add close button
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(dismissVerification)
        )

        presentingViewController.present(navigationController, animated: true)
    }

    // MARK: - Helper Methods

    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "VerifyDocument", bundle: Bundle.module)
    }

    private func getAuthStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: Bundle.module)
    }

    private func createDocumentScanVC() -> UIViewController {
        // Directly open IDScanStepsVC with default document type (Driver's License)
        return IDScanStepsVC(documentType: .driversLicenseOrIDCard)
    }

    private func createFaceOnlyCaptureVC() -> UIViewController {
        let faceStep = IDScanStep(title: "Face")
        let captureVC = IDCaptureVC(documentType: .driversLicenseOrIDCard, stepIndex: 0, step: faceStep)
        captureVC.isFaceOnlyMode = true

        // Set up face capture completion handler
        captureVC.onCaptured = { [weak self, weak captureVC] image in
            guard let self = self, let vc = captureVC else { return }

            // Call reverify API with face image
            guard let email = self.currentEmail, !email.isEmpty else {
                self.failVerification(with: .verificationFailed("Email is required for face detection"))
                return
            }

            guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
                self.failVerification(with: .verificationFailed("Failed to capture face image"))
                return
            }

            Utility.showIndicator()
            AuthServices.shared.reverify(email: email, age: "0", livePhotoData: imageData) { [weak self] statusCode, response in
                Utility.hideIndicator()

                DispatchQueue.main.async {
                    // Dismiss the screen first
                    vc.navigationController?.dismiss(animated: true) {
                        if (200..<300).contains(statusCode), let data = response.documentVerificationData {
                            // Success - call completion with result
                            self?.completionHandler?(BinbagVerificationResult(
                                isVerified: true,
                                documentData: data,
                                error: nil
                            ))
                        } else {
                            // Failed - call completion with error
                            self?.completionHandler?(BinbagVerificationResult(
                                isVerified: false,
                                documentData: response.documentVerificationData,
                                error: .verificationFailed(response.message ?? "Verification failed")
                            ))
                        }
                    }
                }
            } failure: { [weak self] error in
                Utility.hideIndicator()
                DispatchQueue.main.async {
                    vc.navigationController?.dismiss(animated: true) {
                        self?.completionHandler?(BinbagVerificationResult(
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

    @objc private func dismissVerification() {
        // Find the presenting view controller and dismiss
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.dismiss(animated: true) { [weak self] in
                self?.delegate?.binbagVerifyDidCancel()
                self?.completionHandler?(BinbagVerificationResult(
                    isVerified: false,
                    documentData: nil,
                    error: .userCancelled
                ))
            }
        }
    }

    // MARK: - Internal Completion Handler

    /// Called internally when verification completes
    internal func completeVerification(with data: DocumentVerificationData?) {
        let result = BinbagVerificationResult(
            isVerified: data != nil,
            documentData: data,
            error: nil
        )

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.binbagVerifyDidComplete(result: result)
            self?.completionHandler?(result)
        }
    }

    /// Called internally when verification fails
    internal func failVerification(with error: BinbagVerifyError) {
        let result = BinbagVerificationResult(
            isVerified: false,
            documentData: nil,
            error: error
        )

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.binbagVerifyDidComplete(result: result)
            self?.completionHandler?(result)
        }
    }
}

// MARK: - Convenience Extension for UIViewController
public extension UIViewController {

    /// Present BinbagVerify document scan flow
    /// - Parameters:
    ///   - email: User's email address (optional for document scan)
    ///   - completion: Completion handler with the result
    func presentBinbagDocumentScan(
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        BinbagVerify.shared.startVerification(
            from: self,
            type: .documentScan,
            email: email,
            completion: completion
        )
    }

    /// Present BinbagVerify face detection flow
    /// - Parameters:
    ///   - email: User's email address (required for face detection/reverification)
    ///   - completion: Completion handler with the result
    func presentBinbagFaceDetection(
        email: String,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        BinbagVerify.shared.startVerification(
            from: self,
            type: .faceDetection,
            email: email,
            completion: completion
        )
    }

    /// Present BinbagVerify verification flow
    /// - Parameters:
    ///   - type: The type of verification flow
    ///   - email: User's email address (required for faceDetection)
    ///   - completion: Completion handler with the result
    func presentBinbagVerification(
        type: BinbagVerificationType = .documentScan,
        email: String? = nil,
        completion: @escaping (BinbagVerificationResult) -> Void
    ) {
        BinbagVerify.shared.startVerification(
            from: self,
            type: type,
            email: email,
            completion: completion
        )
    }
}
