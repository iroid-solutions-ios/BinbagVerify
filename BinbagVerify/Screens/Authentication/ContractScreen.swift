//
//  ContractScreen.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 11/10/24.
//

import UIKit
import DIVESDK
import DIVESDKCommon

class ContractScreen: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var contractBackgroundView: UIView!
    
    @IBOutlet weak var contractDetailLabel: UILabel!
    
    @IBOutlet weak var signatureTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!

    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Variables
    var sdk: DIVESDK?
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contractBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contractBackgroundView.layer.cornerRadius = 16
        setUpContractDetail()
    }
    
    func initialSetup(){
        signatureTextField.delegate = self
        signatureTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        fullNameTextField.delegate = self
        fullNameTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        birthDateTextField.delegate = self
        birthDateTextField.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        setUpSDK()
        setUpDatePicker()
    }
    
    func setUpDatePicker(){
        let datePickerFrame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 216)
        datePicker = UIDatePicker(frame: datePickerFrame)
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -150, to: Date())
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        birthDateTextField.inputView = datePicker
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(title: Utility.getLocalizedString(value: "CANCEL"), style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, .flexibleSpace(), doneButton], animated: true)

        birthDateTextField.inputAccessoryView = toolBar
    }

    @objc func doneButtonTapped() {
        let formattedDate = formatDate(datePicker.date, format: dd_MM_YYYY)
        birthDateTextField.text = formattedDate
        view.endEditing(true)
        if signatureTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 &&
            fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 && birthDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0
        {
            continueButton.layer.opacity = 1
            continueButton.isUserInteractionEnabled = true
        } else {
            continueButton.layer.opacity = 0.2
            continueButton.isUserInteractionEnabled = false
        }
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    @objc func cancelClick() {
        birthDateTextField.resignFirstResponder()
    }
    
    func setUpContractDetail()  {
        let attributedPlanString = NSMutableAttributedString()
   
        let titleFont = UIFont(name: "SFProDisplay-Bold", size: 36) ?? UIFont.systemFont(ofSize: 17)
        let subTitleFont = UIFont(name: "SFProDisplay-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let containFont = UIFont(name: "SFProDisplay-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        
        let titleFontAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        let subTitleFontAttributes: [NSAttributedString.Key: Any] = [
            .font: subTitleFont,
            .foregroundColor: UIColor.black
        ]
        
        let containFontAttributes: [NSAttributedString.Key: Any] = [
            .font: containFont,
            .foregroundColor: #colorLiteral(red: 0.3921568627, green: 0.4549019608, blue: 0.5450980392, alpha: 1)
        ]
        
        attributedPlanString.append(NSAttributedString(string: "01.\n", attributes: titleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "WE COLLECT BIOMETRIC INFORMATION, WHICH IS SUBJECT TO THE BIOMETRIC INFORMATION PRIVACY ACT 2020: \n\n", attributes: subTitleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "1.1 Biometric information is, for the purpose of verifying the users age, but not limited to: retina or iris scan, voice print and/or a hand and/or face scan; front and back of Drivers License and/or passports; face scan; fingerprint scan; and voice authentication.\n\n1.2 Biometric information does not include: writing samples, written signature, human biological samples, donated organs, tissue or other such samples, height, weight or hair; and \n\n1.3 Does not include any materials collected under the genetic Information Privacy Act 1996.\n\n1.4 You explicitly agree to the collection and retention of the materials detail in clause 2.5 above. We will retain this information for, up to a period of 3 years, upon which time it will be permanently deleted from your record. Should we be required by law, warrant or subpoena to retain this information for a period of longer than three (3) years we will advise you in writing at the last contact address we have on file for you, unless prevent by valid legal instruction.\n\n1.5 If any of Your data is considered Special Category Data, You expressly give Your permission for its collection and use as agreed under these terms.\n\n1.6 Please do not supply any other person's personal data to Us, the data You supply must only be your own.\n\n1.7 All biometric data is protected by the use of a third party vault system which is only accessed when the data held is required for use. \n\n", attributes: containFontAttributes))
        
        attributedPlanString.append(NSAttributedString(string: "02.\n", attributes: titleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "SECURITY OF PERSONAL DATA \n\n", attributes: subTitleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "2.1 We will take appropriate technical and organizational precautions to secure Your personal data and to prevent the loss, misuse or alteration of Your personal data.\n\n2.2 We will store Your personal data on secure servers, personal computers and mobile devices, and in secure manual record-keeping systems. We secure all biometric data in secure, third party, vaults and only access those vaults when information is required.\n\n2.3 Data relating to Your enquiries and financial transactions that is sent from Your web browser to Website and/or Our Software server, or from Website/Our Software server to Your web browser, will be protected using encryption technology.\n\n2.4 Any Biometric data obtained will be held in secure third party vaults which are only accessed when data is required for use.\n\n2.5 You acknowledge that the transmission of unencrypted or inadequately encrypted data over the internet is inherently insecure, and We cannot guarantee the security of data sent over the internet. \n\n", attributes: containFontAttributes))
        
        
        attributedPlanString.append(NSAttributedString(string: "03.\n", attributes: titleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "USAGE - E SIGNATURE REQUIREMENT \n\n", attributes: subTitleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "3.1 It is a Required terms of the contract, under which you use this Software that any user signs this Agreement.\n\n3.2 For your convenience you should sign this agreement in the form of an E Signature.\n\n3.3 please put the instructions as to how they design in the clause.\n\n3.4 You may not use the Software without your E-Signature. \n\n", attributes: containFontAttributes))
        
        attributedPlanString.append(NSAttributedString(string: "04.\n", attributes: titleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "E SIGNATURE \n\n", attributes: subTitleFontAttributes))
        attributedPlanString.append(NSAttributedString(string: "By signing below, you consent to Id-verified.com’s collection, use, disclosure, and storage of your biometric data as described above. \n\n", attributes: containFontAttributes))
        
        contractDetailLabel.attributedText = attributedPlanString
    }
    
    func setUpSDK(){
        print("libToken",libToken)
        if let json = loadJson(filename: "ConfigDemo"), let sdk = DIVESDK(configuration: json, token: secretToken, delegate: self) {
            print("json",json)
            self.sdk = sdk
        }
        print("SDK",self.sdk)
    }
    
    @objc func textFieldTextChanged(_ textField: UITextField) {
        if textField == signatureTextField || textField  == fullNameTextField || textField  == birthDateTextField {
            if signatureTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 &&
                fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 && birthDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0
                
            {
                continueButton.layer.opacity = 1
                continueButton.isUserInteractionEnabled = true
            } else {
                continueButton.layer.opacity = 0.2
                continueButton.isUserInteractionEnabled = false
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func onApproveAndContinue(_ sender: Any) {
//        if let message = checkValidation() {
//            Utility.showAlert(vc: self, message: message)
//        } else {
            let vc = IDScanDocumentTypeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        
//       self.sdk?.start(from: self)
//       }
    }
    
}

extension ContractScreen {
    fileprivate func checkValidation() -> String?{
        if signatureTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.SIGNATURE
        } else if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.FULL_NAME
        } 
//        else if signatureTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
//            return AuthenticationAlertMessage.SIGNATURE_AND_FULL_NAME
//        } 
        else if birthDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return AuthenticationAlertMessage.BIRTHDATE
        }
        return nil
    }
}

//MARK: - UITextFieldDelegate
extension ContractScreen: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.containsEmoji {
            return false
        }
        
        if textField == fullNameTextField || textField == signatureTextField {
            let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
    
}
extension ContractScreen :  DIVESDKDelegate {
    private func openResult(result: [String : Any]) {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted]) {
            //let theJSONText = String(data: theJSONData, encoding: .ascii)
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            //            let resultVC = storyboard.instantiateViewController(withIdentifier: "Result_VC") as! Result_VC
            //            resultVC.loadView()
            //            resultVC.textView.text = theJSONText
            //            self.navigationController?.pushViewController(resultVC, animated: true)
            
            
            if let documentVerificationResult = result["documentVerificationResult"] as? [String: Any],
               let statusString = documentVerificationResult["statusString"] as? String {
                print("Extracted statusString: \(statusString)")
                
                // You can pass statusString to the next screen if needed
                if statusString == "Ok" {
                    if let vc = STORYBOARD.verifyAccount.instantiateViewController(withIdentifier: "VerifiedScreen") as? VerifiedScreen {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if let vc = STORYBOARD.verifyAccount.instantiateViewController(withIdentifier: "VerifyRejectScreen") as? VerifyRejectScreen {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
        }
    }
    
    // MARK: - DIVESDKDelegate
    
    func diveSDKResult(sdk: Any, result: [String : Any]) {
        self.dismissWaitingAlert()
        self.openResult(result: result)
    }
    
    func diveSDKSendingDataStarted(sdk: Any) {
        if let sdk = sdk as? DIVESDK {
            sdk.close()
        }
        self.showWaitingAlert(message: "💭\n\nUploading data")
    }
    
    func diveSDKSendingDataProgress(sdk: Any, progress: Float, requestTime: TimeInterval) {
        let progressPercent = "\(round((progress * 100) * 100) / 100.0)%"
        let progressStr = progress == 1 ? "Validation" : "Uploading data: \(progressPercent)"
        self.showWaitingAlert(message: "💭\n\n\(progressStr)")
    }

    func diveSDKError(sdk: Any, error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showOKAlert(title: "❗️\nError", message: error.localizedDescription)
        }
    }

}


