//
//  ViewController.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 20/07/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let screen = UIStoryboard(name : "Main", bundle : Bundle.main).instantiateViewController(withIdentifier: "DVSSDK_VC") as? DVSSDK_VC {
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
}
