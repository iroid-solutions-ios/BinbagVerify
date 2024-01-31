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
        if let screen = UIStoryboard(name : "Main", bundle : Bundle.main).instantiateViewController(withIdentifier: "DIVESDK_VC") as? DIVESDK_VC {
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
}
