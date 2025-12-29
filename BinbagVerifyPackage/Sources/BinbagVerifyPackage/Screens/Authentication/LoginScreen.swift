//
//  LoginScreen.swift
//  BinbagVerify
//
//  Created by Assistant on 12/12/24.
//

import UIKit

public class LoginScreen: UIViewController {

    // MARK: - UI Elements
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.packageImage(named: "ic_back_arrow") ?? UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your email and verify your face"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .none
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let emailUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let faceDetectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Face Detection", for: .normal)
        button.setTitleColor(UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 0.1)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Store captured face image
    var capturedFaceImage: UIImage?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateButtonState()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailUnderlineView)
        view.addSubview(faceDetectionButton)

        NSLayoutConstraint.activate([
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            // Email underline
            emailUnderlineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            emailUnderlineView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailUnderlineView.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            emailUnderlineView.heightAnchor.constraint(equalToConstant: 1),

            // Face Detection Button
            faceDetectionButton.topAnchor.constraint(equalTo: emailUnderlineView.bottomAnchor, constant: 30),
            faceDetectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            faceDetectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            faceDetectionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        faceDetectionButton.addTarget(self, action: #selector(onFaceDetection), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        emailTextField.delegate = self
    }

    @objc private func onBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func textFieldTextChanged() {
        updateButtonState()
    }

    func updateButtonState() {
        if emailTextField.text.isEmailValid() {
            faceDetectionButton.alpha = 1
            faceDetectionButton.isUserInteractionEnabled = true
        } else {
            faceDetectionButton.alpha = 0.5
            faceDetectionButton.isUserInteractionEnabled = false
        }
    }

    @objc func onFaceDetection() {
        view.endEditing(true)
        // Validate email before opening face detection
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard email?.count ?? 0 > 0, emailTextField.text.isEmailValid() else {
            Utility.showAlert(vc: self, message: AuthenticationAlertMessage.VALID_EMAIL)
            return
        }
        let validEmail = email ?? ""

        // Open face detection screen (face-only mode - hides front/back buttons)
        let faceStep = IDScanStep(title: "Face")
        let captureVC = IDCaptureVC(documentType: .driversLicenseOrIDCard, stepIndex: 0, step: faceStep)
        captureVC.isFaceOnlyMode = true  // Hide front/back buttons
        captureVC.onCaptured = { [weak self] image in
            self?.capturedFaceImage = image
        }
        captureVC.onComplete = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)

            // Call reverify API after face capture
            if let faceImage = self.capturedFaceImage {
                self.callReverifyAPI(email: validEmail, faceImage: faceImage)
            }
        }
        self.navigationController?.pushViewController(captureVC, animated: true)
    }

    private func callReverifyAPI(email: String, faceImage: UIImage) {
        guard let imageData = faceImage.jpegData(compressionQuality: 0.5) else {
            Utility.showAlert(vc: self, message: "Failed to process face image")
            return
        }

        if Utility.isInternetAvailable() {
            Utility.showIndicator()
            AuthServices.shared.reverify(email: email, age: "0", livePhotoData: imageData, success: { [weak self] (statusCode, response) in
                guard let self = self else { return }
                Utility.hideIndicator()

                if let res = response.documentVerificationData {
                    // Debug print using JSONEncoder
                    if let jsonData = try? JSONEncoder().encode(res),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                    }
                    // Navigate to VerifiedScreen with data
                    let storyboard = UIStoryboard(name: "VerifyDocument", bundle: Bundle.module)
                    if let vc = storyboard.instantiateViewController(withIdentifier: "VerifiedScreen") as? VerifiedScreen {
                        vc.verificationData = res
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else if let message = response.message {
                    Utility.showAlert(vc: self, message: message)
                }

            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            })
        } else {
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginScreen: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
}
