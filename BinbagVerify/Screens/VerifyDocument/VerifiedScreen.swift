//
//  VerifiedScreen.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 08/10/24.
//

import UIKit

class VerifiedScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onDone(_ sender: UIButton) {
        signUpAPI()
    }
    

}

//MARK: - API
extension VerifiedScreen {
    func signUpAPI(){
        if Utility.isInternetAvailable(){
            self.view.endEditing(true)
            Utility.showIndicator()
            
            AuthServices.shared.register(parameters: signUpRequest?.toJSON() ?? [:]){ (statusCode, response) in
                Utility.hideIndicator()
                
                let alertController = UIAlertController(title: APPLICATION_NAME, message: "User Registered Successfully", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popToViewController(ofClass: SignUpScreen.self)
                }
 
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            } failure: { [weak self](error) in
                guard let selfScreen = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: selfScreen, message: error)
            }
        } else {
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
