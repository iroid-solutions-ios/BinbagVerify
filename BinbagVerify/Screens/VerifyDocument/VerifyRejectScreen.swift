//
//  VerifyRejectScreen.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 08/10/24.
//

import UIKit

class VerifyRejectScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func onGoToBack(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: ContractScreen.self)
    }
}
