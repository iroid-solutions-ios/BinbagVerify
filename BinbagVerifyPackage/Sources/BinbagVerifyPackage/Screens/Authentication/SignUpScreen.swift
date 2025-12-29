//
//  SignUpScreen.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 07/10/24.
//

import UIKit

public class SignUpScreen: UIViewController {

    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.packageImage(named: "ic_back_arrow") ?? UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // First Name
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your first name"
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // Last Name
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your last name"
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // Phone Number
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "+1"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // Email Address
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Address"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "exaple@gmail.com"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // Terms checkbox
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.packageImage(named: "ic_checkbox_unselected") ?? UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage.packageImage(named: "ic_checkbox_selected") ?? UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.tintColor = UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let termsTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // Footer text
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "2024 Id-verified.com. By submitting this form, you agree to be bound by the terms of service & Privacy Policy & understand that none of your personal information will be sold."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Continue button
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue →", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Login button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.13, green: 0.39, blue: 0.70, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTermsText()
        setupActions()
        updateContinueButtonState()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(firstNameLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameLabel)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(phoneNumberTextField)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(checkboxButton)
        contentView.addSubview(termsTextView)
        contentView.addSubview(footerLabel)
        contentView.addSubview(continueButton)
        contentView.addSubview(loginButton)

        NSLayoutConstraint.activate([
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            // ScrollView
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // First Name
            firstNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),

            // Last Name
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 8),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),

            // Phone Number
            phoneNumberLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 8),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50),

            // Email
            emailLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            // Checkbox and Terms
            checkboxButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            checkboxButton.widthAnchor.constraint(equalToConstant: 28),
            checkboxButton.heightAnchor.constraint(equalToConstant: 28),

            termsTextView.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
            termsTextView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            termsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Footer
            footerLabel.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 40),
            footerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            footerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Continue Button
            continueButton.topAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: 20),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 50),

            // Login Button
            loginButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 12),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func setupTermsText() {
        let attributedString = NSMutableAttributedString()

        let regularFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        let linkFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        let greenColor = UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 1.0)

        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: regularFont,
            .foregroundColor: UIColor.black
        ]

        let termsAttributes: [NSAttributedString.Key: Any] = [
            .font: linkFont,
            .foregroundColor: greenColor,
            .link: "terms://"
        ]

        let privacyAttributes: [NSAttributedString.Key: Any] = [
            .font: linkFont,
            .foregroundColor: greenColor,
            .link: "privacy://"
        ]

        attributedString.append(NSAttributedString(string: "I agree to the ", attributes: regularAttributes))
        attributedString.append(NSAttributedString(string: "Terms & Conditions", attributes: termsAttributes))
        attributedString.append(NSAttributedString(string: " and ", attributes: regularAttributes))
        attributedString.append(NSAttributedString(string: "Privacy Policy", attributes: privacyAttributes))

        termsTextView.attributedText = attributedString
        termsTextView.linkTextAttributes = [.foregroundColor: greenColor]
        termsTextView.delegate = self
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        checkboxButton.addTarget(self, action: #selector(onCheckboxTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self

        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        // Keyboard handling
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapToDismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func onBack() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func onCheckboxTapped() {
        checkboxButton.isSelected.toggle()
        updateContinueButtonState()
    }

    @objc private func textFieldDidChange() {
        updateContinueButtonState()
    }

    private func updateContinueButtonState() {
        let isValid = isFormValid()
        continueButton.alpha = isValid ? 1.0 : 0.5
        continueButton.isUserInteractionEnabled = isValid
    }

    private func isFormValid() -> Bool {
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let phone = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        return !firstName.isEmpty &&
               !lastName.isEmpty &&
               phone.count >= 6 &&
               emailTextField.text.isEmailValid() &&
               checkboxButton.isSelected
    }

    @objc private func onContinue() {
        if let error = checkValidation() {
            Utility.showAlert(vc: self, message: error)
            return
        }

        // Save signup request data
        signUpRequest = SignUpRequest(
            firstName: firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            email: emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            countryCode: "+1",
            phoneNumber: phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        // Navigate to ContractScreen
        let storyboard = UIStoryboard(name: "Authentication", bundle: Bundle.module)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContractScreen") as? ContractScreen {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Failed to instantiate ContractScreen from storyboard")
        }
    }

    @objc private func onLogin() {
        let loginVC = LoginScreen()
        navigationController?.pushViewController(loginVC, animated: true)
    }

    private func checkValidation() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.FULL_NAME
        } else if lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.FULL_NAME
        } else if phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.PHONE_NUMBER
        } else if phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 <= 5 {
            return AuthenticationAlertMessage.MINIMUM_LETTER_PHONE
        } else if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.EMAIL
        } else if !(emailTextField.text.isEmailValid()) {
            return AuthenticationAlertMessage.VALID_EMAIL
        } else if !checkboxButton.isSelected {
            return "Please agree to the Terms & Conditions"
        }
        return nil
    }
}

// MARK: - UITextFieldDelegate
extension SignUpScreen: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }

        if textField == firstNameTextField || textField == lastNameTextField {
            let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }

        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - UITextViewDelegate
extension SignUpScreen: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            // Handle terms tap
            print("Terms tapped")
        } else if URL.scheme == "privacy" {
            // Handle privacy tap
            print("Privacy tapped")
        }
        return false
    }
}
