//
//  LoginScreen.swift
//  BinbagVerify
//
//  Created by Assistant on 12/12/24.
//

import UIKit

class LoginScreen: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var faceDetectionButton: UIButton!

    // Store captured face image
    var capturedFaceImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    func initialSetup() {
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        updateButtonState()
    }

    @objc func textFieldTextChanged(_ textField: UITextField) {
        updateButtonState()
    }

    func updateButtonState() {
        if emailTextField.text.isEmailValid() {
            faceDetectionButton.layer.opacity = 1
            faceDetectionButton.isUserInteractionEnabled = true
        } else {
            faceDetectionButton.layer.opacity = 0.2
            faceDetectionButton.isUserInteractionEnabled = false
        }
    }

    //MARK: - IBActions
    @IBAction func onFaceDetection(_ sender: UIButton) {
        self.view.endEditing(true)
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
                    if let vc = STORYBOARD.verifyAccount.instantiateViewController(withIdentifier: "VerifiedScreen") as? VerifiedScreen {
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

//MARK: - UITextFieldDelegate
extension LoginScreen: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
}
