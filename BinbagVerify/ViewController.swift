//
//  ViewController.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 20/07/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Variables
    let playerViewController = AVPlayerViewController()
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    func setUpInitialDetails(){
        self.setUpVideoPlayer()
    }
    
    @IBAction func onSkip(_ sender: UIButton) {
        self.player?.pause()
        self.player = nil
        if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "SignUpScreen") as? SignUpScreen {
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "ContractScreen") as? ContractScreen {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func onContinue(_ sender: UIButton) {
        self.player?.pause()
        self.player = nil
        if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "SignUpScreen") as? SignUpScreen {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - Setup video Player
extension ViewController{
    
    func setUpVideoPlayer(){
        
        if let videoURL = Bundle.main.url(forResource: "Intoduction", withExtension: "mp4") {
            
            self.player = AVPlayer(url: videoURL)
            
            let playerFrame = CGRect(
                x: self.videoPlayerView.frame.minX,
                y: self.videoPlayerView.frame.minY,
                width: self.videoPlayerView.frame.width,
                height: self.videoPlayerView.frame.height
            )
            
            
            self.playerViewController.player = self.player
            self.playerViewController.view.frame = playerFrame
            self.playerViewController.view.frame = self.videoPlayerView.bounds
            
            addChild(playerViewController)
            self.videoPlayerView.addSubview(playerViewController.view)
            self.playerViewController.didMove(toParent: self)
            self.view.layoutIfNeeded()
            
            self.player?.play()
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidFinishPlaying(_:)),
                name: .AVPlayerItemDidPlayToEndTime,
                object: self.player?.currentItem
            )
            
        } else {
            print("Video file not found.")
        }
        
    }
    
    @objc func videoDidFinishPlaying(_ notification: Notification) {
        self.continueButton.isHidden = false
    }
    
}


//import UIKit
//import WebKit
//
//class ViewController: UIViewController {
//    
//    var webView: WKWebView!
//    let apiKey = "9789e6c5c31d63156e6cc1b87efbdcae11e94baf"
//    let templateID = "yyLZT6hGQU5YHD2BXYzzGX"
//
//    let fullName = "kartik patel 1312"
//    let email = "kartik@iroidsolutions.com"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupWebView()
//        //createAndSendDocument()
//        createSession(for: "yJixjfYdNG34Ek3746KH9i")
//       
//    }
//
//    func setupWebView() {
//        webView = WKWebView(frame: view.bounds)
//        view.addSubview(webView)
//    }
//
//    func createAndSendDocument() {
//        let names = fullName.split(separator: " ")
//        let firstName = String(names.first ?? "")
//        let lastName = names.count > 1 ? String(names[1]) : ""
//
//        let url = URL(string: "https://api.pandadoc.com/public/v1/documents")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let payload: [String: Any] = [
//            "name": "Welcome Agreement",
//            "template_uuid": templateID,
//            "recipients": [
//                [
//                    "email": email,
//                    "first_name": firstName,
//                    "last_name": lastName,
//                    "role": "Client"
//                ]
//            ],
//            "tokens": [
//                ["name": "full_name", "value": fullName]
//            ],
//            "send_email": false // we're going to embed it
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print("Document creation error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let docID = json["id"] as? String {
//                print("✅ Document created: \(docID)")
//                self.checkDocumentStatus(documentID: docID)
//            } else {
//                print("Invalid response: \(String(data: data, encoding: .utf8) ?? "")")
//            }
//        }.resume()
//    }
//
//    func checkDocumentStatus(documentID: String) {
//        let url = URL(string: "https://api.pandadoc.com/public/v1/documents/\(documentID)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print("Error checking status: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let status = json["status"] as? String {
//                print("Document Status: \(status)")
//                
//                if status == "document.sent" || status == "document.ready" {
//                    // Proceed to create session and load the document
//                    self.createSession(for: documentID)
//                } else {
//                    print("Document is still being processed. Try again later.")
//                }
//            }
//        }.resume()
//    }
//
//    
//    func createSession(for documentID: String) {
//        let url = URL(string: "https://api.pandadoc.com/public/v1/documents/\(documentID)/session")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let payload = [
//            "recipient": email,
//            "lifetime": 900
//        ] as [String : Any]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print("Session creation error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
//               // self.fetchSession(for: documentID, sessionID: json["id"] as? String ?? "")
//                let documentURL = "https://app.pandadoc.com/s/\(json["id"] as? String ?? "")"
//                let signURL = URL(string: documentURL)!
//                print("✅ Session URL ready: \(signURL)")
//                DispatchQueue.main.async {
//                    self.webView.load(URLRequest(url: signURL))
//                }
//            } else {
//                print("Invalid session response: \(String(data: data, encoding: .utf8) ?? "")")
//            }
//        }.resume()
//    }
//    
//    func fetchSession(for documentID: String, sessionID: String) {
//        let url = URL(string: "https://api.pandadoc.com/public/v1/documents/\(documentID)/session/\(sessionID)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print("Session fetch error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let urlStr = json["url"] as? String,
//               let signURL = URL(string: urlStr) {
//                print("✅ Session URL ready: \(urlStr)")
//                DispatchQueue.main.async {
//                    self.webView.load(URLRequest(url: signURL))
//                }
//            } else {
//                print("Invalid session fetch response: \(String(data: data, encoding: .utf8) ?? "")")
//            }
//        }.resume()
//    }
//
//}
//
//
////import UIKit
////import WebKit
////
////class PandaDocSelfSignViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
////    
////    // The document ID that needs to be signed
////    var documentId: String?
////    
////    private var webView: WKWebView!
////    private var activityIndicator: UIActivityIndicatorView!
////    private let pandaDocService = PandaDocService(apiKey: "YOUR_API_KEY_HERE")
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        
////        setupUI()
////        loadDocument()
////    }
////    
////    private func setupUI() {
////        title = "Sign Document"
////        
////        // Configure web view with JavaScript interface
////        let configuration = WKWebViewConfiguration()
////        let userContentController = WKUserContentController()
////        userContentController.add(self, name: "signatureHandler")
////        configuration.userContentController = userContentController
////        
////        webView = WKWebView(frame: .zero, configuration: configuration)
////        webView.navigationDelegate = self
////        webView.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(webView)
////        
////        // Add activity indicator
////        activityIndicator = UIActivityIndicatorView(style: .large)
////        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
////        activityIndicator.hidesWhenStopped = true
////        view.addSubview(activityIndicator)
////        
////        // Setup constraints
////        NSLayoutConstraint.activate([
////            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
////            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
////            
////            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
////        ])
////        
////        // Add buttons to navigation bar
////        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
////        navigationItem.leftBarButtonItem = cancelButton
////        
////        let completeButton = UIBarButtonItem(title: "Complete", style: .done, target: self, action: #selector(completeTapped))
////        navigationItem.rightBarButtonItem = completeButton
////    }
////    
////    @objc private func cancelTapped() {
////        dismiss(animated: true)
////    }
////    
////    @objc private func completeTapped() {
////        // Trigger document completion via JavaScript
////        webView.evaluateJavaScript("completeDocument();") { (result, error) in
////            if let error = error {
////                self.showError(message: error.localizedDescription)
////            }
////        }
////    }
////    
////    private func loadDocument() {
////        guard let documentId = documentId else {
////            showError(message: "Document ID is missing")
////            return
////        }
////        
////        activityIndicator.startAnimating()
////        
////        // Get a session URL for embedded signing
////        pandaDocService.createEmbeddedSigningSession(documentId: documentId) { [weak self] result in
////            guard let self = self else { return }
////            
////            switch result {
////            case .success(let sessionUrl):
////                DispatchQueue.main.async {
////                    self.loadEmbeddedSession(url: sessionUrl)
////                }
////            case .failure(let error):
////                DispatchQueue.main.async {
////                    self.activityIndicator.stopAnimating()
////                    self.showError(message: error.localizedDescription)
////                }
////            }
////        }
////    }
////    
////    private func loadEmbeddedSession(url: String) {
////        guard let sessionUrl = URL(string: url) else {
////            activityIndicator.stopAnimating()
////            showError(message: "Invalid session URL")
////            return
////        }
////        
////        // Load the embedded signing session
////        let request = URLRequest(url: sessionUrl)
////        webView.load(request)
////    }
////    
////    // MARK: - WKNavigationDelegate
////    
////    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////        activityIndicator.stopAnimating()
////        
////        // Inject JavaScript to handle signature events
////        let script = """
////        function completeDocument() {
////            // This function would use PandaDoc JS SDK to complete the document
////            // For example: pandaDocSDK.completeDocument();
////            
////            // For now, we'll just notify our native code
////            window.webkit.messageHandlers.signatureHandler.postMessage('completed');
////        }
////        
////        // Add event listeners for PandaDoc events
////        document.addEventListener('pandadoc:signed', function() {
////            window.webkit.messageHandlers.signatureHandler.postMessage('signed');
////        });
////        
////        document.addEventListener('pandadoc:completed', function() {
////            window.webkit.messageHandlers.signatureHandler.postMessage('completed');
////        });
////        """
////        
////        webView.evaluateJavaScript(script) { (_, error) in
////            if let error = error {
////                print("Error injecting JavaScript: \(error)")
////            }
////        }
////    }
////    
////    // MARK: - WKScriptMessageHandler
////    
////    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
////        if message.name == "signatureHandler" {
////            if let messageString = message.body as? String {
////                switch messageString {
////                case "signed":
////                    print("Document has been signed")
////                case "completed":
////                    handleDocumentCompleted()
////                default:
////                    print("Unknown message: \(messageString)")
////                }
////            }
////        }
////    }
////    
////    private func handleDocumentCompleted() {
////        // Handle document completion
////        let alert = UIAlertController(title: "Success", message: "Document has been completed successfully", preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
////            self.dismiss(animated: true)
////        })
////        present(alert, animated: true)
////    }
////    
////    private func showError(message: String) {
////        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default))
////        present(alert, animated: true)
////    }
////}
////
////// MARK: - PandaDoc API Service
////
////class PandaDocService {
////    private let apiKey: String
////    private let baseUrl = "https://api.pandadoc.com/public/v1"
////    
////    init(apiKey: String) {
////        self.apiKey = apiKey
////    }
////    
////    // Create a session for embedded signing
////    func createEmbeddedSigningSession(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {
////        guard let url = URL(string: "\(baseUrl)/documents/\(documentId)/session-embedded") else {
////            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
////            return
////        }
////        
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        
////        // Parameters for embedded signing session
////        // Adjust these based on your specific requirements
////        let parameters: [String: Any] = [
////            "recipient": "self", // Indicate self-signing
////            "lifetime": 3600,    // Session lifetime in seconds
////            "settings": [
////                "show_toolbar": true,
////                "show_navigation": true,
////                "show_send_button": false,
////                "show_preview": true,
////                "show_reject_button": false
////            ]
////        ]
////        
////        do {
////            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
////        } catch {
////            completion(.failure(error))
////            return
////        }
////        
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
////                DispatchQueue.main.async {
////                    completion(.failure(error))
////                }
////                return
////            }
////            
////            guard let data = data else {
////                DispatchQueue.main.async {
////                    completion(.failure(NSError(domain: "No data received", code: 0)))
////                }
////                return
////            }
////            
////            do {
////                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
////                   let sessionUrl = json["url"] as? String {
////                    DispatchQueue.main.async {
////                        completion(.success(sessionUrl))
////                    }
////                } else {
////                    DispatchQueue.main.async {
////                        completion(.failure(NSError(domain: "Invalid response format", code: 0)))
////                    }
////                }
////            } catch {
////                DispatchQueue.main.async {
////                    completion(.failure(error))
////                }
////            }
////        }.resume()
////    }
////    
////    // Create document from template with pre-assigned fields for self-signing
////    func createDocumentFromTemplate(templateId: String, signerName: String, signerEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
////        guard let url = URL(string: "\(baseUrl)/documents") else {
////            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
////            return
////        }
////        
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        
////        // Create document from template with the current user as the signer
////        let parameters: [String: Any] = [
////            "template_uuid": templateId,
////            "name": "Document for self-signing",
////            "recipients": [
////                [
////                    "email": signerEmail,
////                    "first_name": signerName,
////                    "last_name": "",
////                    "role": "signer",
////                    "signing_order": 1
////                ]
////            ],
////            "parse_form_fields": true
////        ]
////        
////        do {
////            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
////        } catch {
////            completion(.failure(error))
////            return
////        }
////        
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
////                DispatchQueue.main.async {
////                    completion(.failure(error))
////                }
////                return
////            }
////            
////            guard let data = data else {
////                DispatchQueue.main.async {
////                    completion(.failure(NSError(domain: "No data received", code: 0)))
////                }
////                return
////            }
////            
////            do {
////                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
////                   let documentId = json["id"] as? String {
////                    DispatchQueue.main.async {
////                        completion(.success(documentId))
////                    }
////                } else {
////                    DispatchQueue.main.async {
////                        completion(.failure(NSError(domain: "Invalid response format", code: 0)))
////                    }
////                }
////            } catch {
////                DispatchQueue.main.async {
////                    completion(.failure(error))
////                }
////            }
////        }.resume()
////    }
////    
////    // Change document status to 'document.draft.sent'
////    func sendDocument(documentId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
////        guard let url = URL(string: "\(baseUrl)/documents/\(documentId)/send") else {
////            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
////            return
////        }
////        
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.addValue("API-Key \(apiKey)", forHTTPHeaderField: "Authorization")
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        
////        let parameters: [String: Any] = [
////            "silent": true
////        ]
////        
////        do {
////            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
////        } catch {
////            completion(.failure(error))
////            return
////        }
////        
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
////                DispatchQueue.main.async {
////                    completion(.failure(error))
////                }
////                return
////            }
////            
////            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
////                DispatchQueue.main.async {
////                    completion(.success(true))
////                }
////            } else {
////                DispatchQueue.main.async {
////                    completion(.failure(NSError(domain: "Failed to send document", code: 0)))
////                }
////            }
////        }.resume()
////    }
////}
////
////// MARK: - Implementation for document creation and signing
////
////class DocumentSelfSigningManager {
////    private let pandaDocService: PandaDocService
////    private weak var presentingViewController: UIViewController?
////    
////    init(apiKey: String, presentingViewController: UIViewController) {
////        self.pandaDocService = PandaDocService(apiKey: apiKey)
////        self.presentingViewController = presentingViewController
////    }
////    
////    func createAndPresentDocumentForSigning(templateId: String, signerName: String, signerEmail: String) {
////        // Show loading indicator
////        let loadingAlert = UIAlertController(title: "Processing", message: "Creating document...", preferredStyle: .alert)
////        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
////        loadingIndicator.hidesWhenStopped = true
////        loadingIndicator.style = .medium
////        loadingIndicator.startAnimating()
////        loadingAlert.view.addSubview(loadingIndicator)
////        presentingViewController?.present(loadingAlert, animated: true)
////        
////        // Step 1: Create document from template
////        pandaDocService.createDocumentFromTemplate(templateId: templateId, signerName: signerName, signerEmail: signerEmail) { [weak self] result in
////            guard let self = self else { return }
////            
////            switch result {
////            case .success(let documentId):
////                // Step 2: Send document to make it available for signing
////                self.pandaDocService.sendDocument(documentId: documentId) { sendResult in
////                    switch sendResult {
////                    case .success:
////                        // Step 3: Open document for self-signing
////                        DispatchQueue.main.async {
////                            loadingAlert.dismiss(animated: true) {
////                                self.presentSigningViewController(documentId: documentId)
////                            }
////                        }
////                    case .failure(let error):
////                        DispatchQueue.main.async {
////                            loadingAlert.dismiss(animated: true) {
////                                self.showError(message: "Failed to send document: \(error.localizedDescription)")
////                            }
////                        }
////                    }
////                }
////            case .failure(let error):
////                DispatchQueue.main.async {
////                    loadingAlert.dismiss(animated: true) {
////                        self.showError(message: "Failed to create document: \(error.localizedDescription)")
////                    }
////                }
////            }
////        }
////    }
////    
////    private func presentSigningViewController(documentId: String) {
////        let signatureVC = PandaDocSelfSignViewController()
////        signatureVC.documentId = documentId
////        
////        let navController = UINavigationController(rootViewController: signatureVC)
////        presentingViewController?.present(navController, animated: true)
////    }
////    
////    private func showError(message: String) {
////        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default))
////        presentingViewController?.present(alert, animated: true)
////    }
////}
////
////// MARK: - Example Usage
////
////class ViewController: UIViewController {
////    
////    private let apiKey = "9789e6c5c31d63156e6cc1b87efbdcae11e94baf"
////    private var documentManager: DocumentSelfSigningManager!
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        documentManager = DocumentSelfSigningManager(apiKey: apiKey, presentingViewController: self)
////    }
////    
////    @IBAction func createDocumentForSigning(_ sender: Any) {
////        // Replace with your template ID
////        let templateId = "yyLZT6hGQU5YHD2BXYzzGX"
////        
////        // Replace with user's information
////        let signerName = "iroid dev"
////        let signerEmail = "nil@iroidsolutions.com"
////        
////        documentManager.createAndPresentDocumentForSigning(
////            templateId: templateId,
////            signerName: signerName,
////            signerEmail: signerEmail
////        )
////    }
////}
