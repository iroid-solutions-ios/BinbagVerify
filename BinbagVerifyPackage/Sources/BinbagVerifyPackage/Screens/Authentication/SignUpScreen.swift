//
//  SignUpScreen.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 07/10/24.
//

import UIKit

class SignUpScreen: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var selectTermsAndCondition: UIButton!
    
    @IBOutlet weak var termsConditionTextView: UITextView!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpTextView()
    }
    
    func initialSetup(){
        firstNameTextField.delegate = self
        firstNameTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        lastNameTextField.delegate = self
        lastNameTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
    }
    
    func setUpTextView()  {
        let attributedPlanString = NSMutableAttributedString()

        let HeighlightedFont = UIFont(name: "SFProDisplay-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let font = UIFont(name: "SFProDisplay-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: HeighlightedFont,
            .link: "Terms",
            .foregroundColor: #colorLiteral(red: 0.2274509804, green: 0.7098039216, blue: 0.2901960784, alpha: 1)
        ]
        
        let privacyAttributes: [NSAttributedString.Key: Any] = [
            .font: HeighlightedFont,
            .link: "PrivacyPolicy",
            .foregroundColor: #colorLiteral(red: 0.2274509804, green: 0.7098039216, blue: 0.2901960784, alpha: 1)
        ]
        
        attributedPlanString.append(NSAttributedString(string: "I agree to the ", attributes: regularAttributes))
        attributedPlanString.append(NSAttributedString(string: "Terms & Conditions ", attributes: linkAttributes))
        attributedPlanString.append(NSAttributedString(string: "and ", attributes: regularAttributes))
        attributedPlanString.append(NSAttributedString(string: "Privacy Policy", attributes: privacyAttributes))
        
        termsConditionTextView.linkTextAttributes = [
            .foregroundColor: #colorLiteral(red: 0.2274509804, green: 0.7098039216, blue: 0.2901960784, alpha: 1)
        ]
        termsConditionTextView.attributedText = attributedPlanString
        termsConditionTextView.textAlignment = .left
        termsConditionTextView.isEditable = false
        termsConditionTextView.isSelectable = true
    }
    
    
    @objc func textFieldTextChanged(_ textField: UITextField) {
        if textField == firstNameTextField || textField  == lastNameTextField || textField  == phoneNumberTextField || textField  == emailTextField{
            if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 &&
                lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 && phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 6 && emailTextField.text.isEmailValid() &&
                selectTermsAndCondition.isSelected {
                continueButton.layer.opacity = 1
                continueButton.isUserInteractionEnabled = true
            } else {
                continueButton.layer.opacity = 0.2
                continueButton.isUserInteractionEnabled = false
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func onSelectCheckBox(_ sender: UIButton) {
        selectTermsAndCondition.isSelected.toggle()
        selectTermsAndCondition.setImage(selectTermsAndCondition.isSelected ? UIImage(named: "ic_checkbox_selected") : UIImage(named: "ic_checkbox_unselected"), for: .normal)
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 &&
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 && phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 6 && emailTextField.text.isEmailValid() &&
            selectTermsAndCondition.isSelected {
            continueButton.layer.opacity = 1
            continueButton.isUserInteractionEnabled = true
        } else {
            continueButton.layer.opacity = 0.2
            continueButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func onContinue(_ sender: UIButton) {
        if let error = checkValidation() {
            Utility.showAlert(vc: self, message: error)
        } else {
            //signUpAPI(residenceId: selectResidenceId)
            if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "ContractScreen") as? ContractScreen {
                signUpRequest = SignUpRequest(firstName: firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                                              email: emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), lastName: lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                                                                countryCode: "+1",
                                                                phoneNumber: phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
                // Debug print using toParameters
                print(signUpRequest?.toParameters() ?? [:])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction func onLogin(_ sender: UIButton) {
        // Open LoginScreen
        if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "LoginScreen") as? LoginScreen {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

//MARK: - Validation
extension SignUpScreen {
    fileprivate func checkValidation() -> String?{
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
        }
        return nil
    }
}

extension SignUpScreen: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let link = URL.absoluteString
        if(link == "Terms") {
            //            let vc = STORYBOARD.setting.instantiateViewController(withIdentifier: "WebviewScreen") as! WebviewScreen
            //            vc.status = URLLinkStatus.TERMS_AND_CONDITION
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(link == "PrivacyPolicy") {
            //            let vc = STORYBOARD.setting.instantiateViewController(withIdentifier: "WebviewScreen") as! WebviewScreen
            //            vc.status = URLLinkStatus.PRIVACY_POLICY
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
    
    
}

//MARK: - UITextFieldDelegate
extension SignUpScreen: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    
}
