//
//  ViewController.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 20/07/23.
//

import UIKit
import BinbagVerifyPackage

class ViewController: UIViewController {

    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BinbagVerify"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Identity Verification SDK"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Email Text Field
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // Button 1: Document Scan
    private let documentScanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Document Scan", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Button 2: Face Detection
    private let faceDetectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Face Detection", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(documentScanButton)
        view.addSubview(faceDetectionButton)

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),

            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
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
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            // Face Detection Button (bottom)
            faceDetectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            faceDetectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            faceDetectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            faceDetectionButton.heightAnchor.constraint(equalToConstant: 50),

            // Document Scan Button (above face detection)
            documentScanButton.bottomAnchor.constraint(equalTo: faceDetectionButton.topAnchor, constant: -16),
            documentScanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            documentScanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            documentScanButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    private func setupActions() {
        documentScanButton.addTarget(self, action: #selector(onDocumentScan), for: .touchUpInside)
        faceDetectionButton.addTarget(self, action: #selector(onFaceDetection), for: .touchUpInside)
    }

    // MARK: - Actions

    /// Validate email and return it if valid
    private func validateEmail() -> String? {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            showOKAlert(title: "Error", message: "Please enter your email")
            return nil
        }

        // Basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            showOKAlert(title: "Error", message: "Please enter a valid email")
            return nil
        }

        return email
    }

    /// Button 1: Opens IDScanStepsVC for document scanning
    @objc private func onDocumentScan() {
        hideKeyboard()

        guard let email = validateEmail() else { return }

        BinbagVerify.startDocumentScan(email: email) { [weak self] result in
            self?.showVerificationResult(result, title: "Document Scan Result")
        }
    }

    /// Button 2: Opens face detection screen directly
    @objc private func onFaceDetection() {
        hideKeyboard()

        guard let email = validateEmail() else { return }

        BinbagVerify.startFaceDetection(email: email) { [weak self] result in
            self?.showVerificationResult(result, title: "Face Detection Result")
        }
    }

    /// Show verification result in popup
    private func showVerificationResult(_ result: BinbagVerificationResult, title: String) {
        var message = ""

        if result.isVerified {
            message += "Status: Verified\n\n"

            if let diveResponse = result.documentData?.diveResponse {
                // Document Info
                if let document = diveResponse.document {
                    message += "--- Document Info ---\n"
                    if let fullName = document.fullName { message += "Name: \(fullName)\n" }
                    if let firstName = document.firstName { message += "First Name: \(firstName)\n" }
                    if let familyName = document.familyName { message += "Last Name: \(familyName)\n" }
                    if let dob = document.dob { message += "DOB: \(dob)\n" }
                    if let gender = document.gender { message += "Gender: \(gender)\n" }
                    if let idNumber = document.id { message += "ID Number: \(idNumber)\n" }
                    if let address = document.address { message += "Address: \(address)\n" }
                    if let city = document.city { message += "City: \(city)\n" }
                    if let state = document.state { message += "State: \(state)\n" }
                    if let zip = document.zip { message += "Zip: \(zip)\n" }
                    if let issued = document.issued { message += "Issue Date: \(issued)\n" }
                    if let expires = document.expires { message += "Expiry Date: \(expires)\n" }
                    message += "\n"
                }

                // Verification Results
                if let docVerification = diveResponse.documentVerificationResult {
                    message += "--- Verification ---\n"
                    if let ocr = docVerification.isOcrSuccess { message += "OCR: \(ocr ? "Pass" : "Fail")\n" }
                    if let mrz = docVerification.isMrzSuccess { message += "MRZ: \(mrz ? "Pass" : "Fail")\n" }
                    if let barcode = docVerification.isPdf417Success { message += "Barcode: \(barcode ? "Pass" : "Fail")\n" }
                    if let confidence = docVerification.documentConfidence { message += "Confidence: \(confidence)%\n" }
                    message += "\n"
                }

                // Face Match
                if let faceMatch = diveResponse.faceMatchVerificationResult {
                    message += "--- Face Match ---\n"
                    if let confidence = faceMatch.faceMatchConfidence {
                        message += "Match: \(confidence > 50 ? "Yes" : "No")\n"
                        message += "Confidence: \(confidence)%\n"
                    }
                    if let ageCheck = faceMatch.isAgeCheckSuccess { message += "Age Check: \(ageCheck ? "Pass" : "Fail")\n" }
                    if let genderCheck = faceMatch.isGenderCheckSuccess { message += "Gender Check: \(genderCheck ? "Pass" : "Fail")\n" }
                    message += "\n"
                }

                // Anti-Spoofing
                if let antiSpoof = diveResponse.antiSpoofingVerificationResult {
                    message += "--- Anti-Spoofing ---\n"
                    if let dataTamper = antiSpoof.isDataFieldsTampered { message += "Data Tampering: \(dataTamper ? "Detected" : "None")\n" }
                    if let photoTamper = antiSpoof.isPhotoFromDocumentTampered { message += "Photo Tampering: \(photoTamper ? "Detected" : "None")\n" }
                    if let confidence = antiSpoof.antiSpoofingFaceImageConfidence { message += "Face Confidence: \(confidence)%\n" }
                }

                // Request ID
                if let requestId = diveResponse.requestId {
                    message += "\nRequest ID: \(requestId)"
                }
            }

            if message == "Status: Verified\n\n" {
                message = "Verification Successful!"
            }

        } else if let error = result.error {
            message = "Status: Failed\n\nError: \(error.localizedDescription)"
        } else {
            message = "Status: Cancelled"
        }

        showResultAlert(title: title, message: message)
    }

    /// Show scrollable result alert
    private func showResultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        // Create scrollable text view for long content
        let textView = UITextView()
        textView.text = message
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false

        alert.view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
            textView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -50),
            alert.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        ])

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
