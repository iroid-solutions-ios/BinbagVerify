//
//  AppDelegate.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 20/07/23.
//

import UIKit
import IQKeyboardManagerSwift


@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navVC : UINavigationController?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        setUpViewController()
        return true
    }
    
    func setUpViewController() {
        if let vc = STORYBOARD.main.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.navVC = UINavigationController(rootViewController: vc)
            self.navVC?.isNavigationBarHidden = true
            self.navVC?.interactivePopGestureRecognizer?.isEnabled = false
            self.navVC?.interactivePopGestureRecognizer?.delegate = nil
            self.window?.rootViewController = nil
            self.window?.rootViewController = navVC
            self.window?.makeKeyAndVisible()
        }
    }

}


func loadJson(filename fileName: String) -> [String: Any]? {
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any] {
                return jsonResult
            }
        } catch {
            print("error:\(error)")
        }
    }
    
    return nil
}


extension UIViewController {
    func showOKAlert(title: String?, message: String?) {
        self.dismissWaitingAlert()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
//    func showWaitingAlert(message: String, for sec: TimeInterval? = nil) {
//        if let alertController = self.currentWaitingAlertController() {
//            UIView.transition(with: alertController.view, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
//                alertController.message = message
//            }, completion: nil)
//        } else {
//            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//            alertController.view.tag = 938468347
//            self.present(alertController, animated: true)
//        }
//        
//        if let sec = sec {
//            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
//                self.dismissWaitingAlert()
//            }
//        }
//    }
    
    func showWaitingAlert(message: String, for sec: TimeInterval? = nil, image: UIImage? = UIImage(resource: .icLogo)) {
        if let alertController = self.currentWaitingAlertController() {
            // Update the message of the existing alert
            UIView.transition(with: alertController.view, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                alertController.message = message
            }, completion: nil)
        } else {
            // Create a new alert controller
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.view.tag = 938468347
            
            // Add an image view to the alert controller if image is provided
            if let image = image {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // Adjust the frame as needed
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                
                // Add the imageView to the alertController's view
                alertController.view.addSubview(imageView)
                
                // Set auto-layout constraints for the imageView
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
                    imageView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 16),
                    imageView.widthAnchor.constraint(equalToConstant: 50),
                    imageView.heightAnchor.constraint(equalToConstant: 50)
                ])
            }

            self.present(alertController, animated: true)
        }
        
        // Automatically dismiss after a certain time interval, if specified
        if let sec = sec {
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.dismissWaitingAlert()
            }
        }
    }

    
    func dismissWaitingAlert() {
        if let alertController = self.currentWaitingAlertController() {
            alertController.dismiss(animated: true)
        }
    }
    
    fileprivate func currentWaitingAlertController() -> UIAlertController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        
        if let alertController = topController as? UIAlertController {
            if alertController.actions.count == 0 && alertController.view.tag == 938468347 {
                return alertController
            }
        }
        
        return nil
    }
}
