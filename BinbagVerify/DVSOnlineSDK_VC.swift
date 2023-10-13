//
//  DVSOnlineSDK_VC.swift
//  DVSSDK
//
//  Created by AKorotkov on 25.10.2022.
//

import Foundation
import UIKit
import DVSOnlineSDK
import DVSSDKCommon

class DVSOnlineSDK_VC: UIViewController, DVSSDKDelegate {
    
    var sdk: DVSOnlineSDK?


    
    @IBOutlet weak var dvsConfigButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dvsConfigButton.layer.borderWidth = 1
        self.dvsConfigButton.layer.borderColor = UIColor(white: 0, alpha: 0.12).cgColor
    }
    
    @IBAction func loadConfigAction(_ sender: UIButton) {
        self.showWaitingAlert(message: "⚙️\n\nLoading configuration")
        
        DVSOnlineSDK.getApplicantID { [weak self] result in
            guard let strongSelf = self else { return }
            // MARK: - <# #>
            switch result {
                case .success(let applicantID):
                print(applicantID)
                strongSelf.sdk = DVSOnlineSDK(applicantID: applicantID, integrationID: libToken, token: secretToken, delegate: strongSelf)
                    strongSelf.sdk?.loadConfiguration() { [weak strongSelf] error in
                        guard let strongSelf2 = strongSelf else { return }
                        
                        if let error = error {
                            strongSelf2.showOKAlert(title: "❗️\nError", message: error.localizedDescription)
                        } else {
                            strongSelf2.showWaitingAlert(message: "✅\n\nConfig loaded", for: 0.7)
                            strongSelf2.startButton.isEnabled = true
                        }
                    }
                case .failure(let error):
                    strongSelf.showOKAlert(title: "❗️\nError", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func startAction(_ sender: Any) {
        self.sdk?.start(from: self)
    }
    
    private func openResult(result: [String : Any]) {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData, encoding: .ascii)
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "Result_VC") as! Result_VC
            resultVC.loadView()
            resultVC.textView.text = theJSONText
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    // MARK: - DVSSDKDelegate

    func dvsSDKResult(sdk: Any, result: [String : Any]) {
        self.dismissWaitingAlert()
        self.openResult(result: result)
    }
    
    func dvsSDKSendingDataStarted(sdk: Any) {
        if let sdk = sdk as? DVSOnlineSDK {
            sdk.close()
        }
        
        self.showWaitingAlert(message: "💭\n\nUploading data")
    }
    
    func dvsSDKSendingDataProgress(sdk: Any, progress: Float, requestTime: TimeInterval) {
        let progressPercent = requestTime > 1 ? ": \(round((progress * 100) * 100) / 100.0)%" : ""
        let progressStr = progress == 1 ? "Validation" : "Uploading data\(progressPercent)"
        self.showWaitingAlert(message: "💭\n\n\(progressStr)")
    }

    func dvsSDKError(sdk: Any, error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showOKAlert(title: "❗️\nError", message: error.localizedDescription)
        }
    }
}

public typealias DVSOnlineSDKApplicantIDResult = Result<String, Error>

extension DVSOnlineSDK {
    class func getApplicantID(handler block: @escaping (DVSOnlineSDKApplicantIDResult) -> Void) {
        let url = "https://api-dvsonline.idscan.net/api/v2/private/Applicants"
        let params = ["firstName" : "Marc", "lastName" : "Vincent", "phone" : "+123457896"]
        
        DVSNetwork.request(url: url, method: .post, parameters: params, token: secretToken) { result in
            switch result {
                case .success(let data):
                    if let applicantId = data["applicantId"] as? String {
                        block(.success(applicantId))
                    } else {
                        block(.failure(DVSError.somethingWentWrong()))
                    }
                case .failure(let error):
                    block(.failure(error))
            }
        }
    }
}
