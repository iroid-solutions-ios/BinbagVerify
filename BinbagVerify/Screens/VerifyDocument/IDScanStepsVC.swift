//
//  IDScanStepsVC.swift
//  BinbagVerify
//
//  Created by Assistant on 12/11/2025.
//

import UIKit

final class IDScanStepsVC: UIViewController {
    
    fileprivate enum StepStatus {
        case pending
        case inProgress
        case completed
    }
    
    private let documentType: IDDocumentType
    private let steps: [IDScanStep]
    private var currentStepIndex: Int = 0
    private var stepStatuses: [StepStatus]
    
    private let titleLabel = UILabel()
    private let docTypeButton = UIButton(type: .system)
    private let stepsStack = UIStackView()
    private var stepCards: [StepCardView] = []
    private let continueButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let startButton = UIButton(type: .system)
    private var capturedImages: [UIImage?]
    
    init(documentType: IDDocumentType) {
        self.documentType = documentType
        self.steps = documentType.steps
        self.stepStatuses = documentType.steps.map { _ in .pending }
        self.capturedImages = documentType.steps.map { _ in nil }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "ID Validation"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If user hasn't started yet, highlight first step as enabled
        let hasAnyNonPending = stepStatuses.contains { status in
            switch status {
                case .pending: return false
                case .inProgress, .completed: return true
            }
        }
        if !hasAnyNonPending, !stepStatuses.isEmpty {
            stepStatuses[0] = .inProgress
            currentStepIndex = 0
        }
        refreshDocTypeTitle()
        updateStepCards()
    }
    
    private func setupUI() {
        // Big screen title
        let bigTitle = UILabel()
        bigTitle.text = "ID Validation"
        bigTitle.font = .systemFont(ofSize: 32, weight: .heavy)
        bigTitle.textColor = .label
        bigTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Document type
        docTypeButton.setTitle(documentType.title, for: .normal)
        docTypeButton.setTitleColor(.label, for: .normal)
        docTypeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        docTypeButton.contentHorizontalAlignment = .left
        docTypeButton.addTarget(self, action: #selector(changeDocType), for: .touchUpInside)
        docTypeButton.translatesAutoresizingMaskIntoConstraints = false
        docTypeButton.backgroundColor = .systemBackground
        docTypeButton.layer.cornerRadius = 8
        docTypeButton.layer.borderWidth = 1
        docTypeButton.layer.borderColor = UIColor.systemGray5.cgColor
        docTypeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 40)
        docTypeButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        // Trailing chevron
        let docChevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        docChevron.tintColor = .tertiaryLabel
        docChevron.translatesAutoresizingMaskIntoConstraints = false
        docTypeButton.addSubview(docChevron)
        NSLayoutConstraint.activate([
            docChevron.centerYAnchor.constraint(equalTo: docTypeButton.centerYAnchor),
            docChevron.trailingAnchor.constraint(equalTo: docTypeButton.trailingAnchor, constant: -14)
        ])
        
        // Section title
        titleLabel.text = "Steps"
        titleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Steps stack
        stepsStack.axis = .vertical
        stepsStack.spacing = 16
        stepsStack.translatesAutoresizingMaskIntoConstraints = false
        buildStepCards()
        
        // Continue button
        continueButton.setTitle("Continue", for: .normal)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = UIColor.systemBlue
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 8
        continueButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        continueButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        // Submit button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = UIColor.systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        submitButton.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        submitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        submitButton.isHidden = true
        
        // Back button
        backButton.setTitle("Back", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.backgroundColor = UIColor.systemGray6
        backButton.setTitleColor(.label, for: .normal)
        backButton.layer.cornerRadius = 8
        backButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        backButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        // Start button
        startButton.setTitle("Start", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = UIColor.systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        startButton.addTarget(self, action: #selector(startFlow), for: .touchUpInside)
        startButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        // Reset button
        resetButton.setTitle("Reset All", for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.backgroundColor = UIColor.systemGray6
        resetButton.setTitleColor(.label, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        resetButton.addTarget(self, action: #selector(onResetAll), for: .touchUpInside)
        resetButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        // Layout
        let buttons = UIStackView(arrangedSubviews: [backButton, resetButton, continueButton, startButton, submitButton])
        buttons.axis = .horizontal
        buttons.spacing = 16
        buttons.distribution = .fillEqually
        
        // Flexible spacer to push buttons to bottom
        let flexibleSpacer = UIView()
        flexibleSpacer.translatesAutoresizingMaskIntoConstraints = false
        flexibleSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        flexibleSpacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let content = UIStackView(arrangedSubviews: [bigTitle, labeled("Document type"), docTypeButton, titleLabel, stepsStack, flexibleSpacer, buttons])
        content.axis = .vertical
        content.spacing = 16
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        updateBottomButtonsVisibility()
    }
    
    // MARK: - Actions
    @objc private func changeDocType() {
        // Pop back to change
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onContinue() {
        if currentStepIndex < steps.count {
            openCapture(for: currentStepIndex)
        } else {
            if let vc = STORYBOARD.verifyAccount.instantiateViewController(withIdentifier: "VerifiedScreen") as? VerifiedScreen {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc private func onSubmit() {
        // Build payload from captured images and fire multipart upload.
        let typeCode = apiDocumentTypeCode()
        let images = resolvedCapturedImages()
        // TODO: wire real age/email from your user model
        let age = "23"
        let email = "kartik.iroid@gmail.com"
        uploadVerification(documentType: "\(typeCode)",
                           documentFront: images.front?.jpegData(compressionQuality: 0.5) ?? Data(),
                           documentBack: images.back?.jpegData(compressionQuality: 0.5) ?? Data(),
                           livePhoto: images.live?.jpegData(compressionQuality: 0.5) ?? Data(),
                           age: age,
                           email: email)
    }
    
    @objc private func startFlow() {
        // If nothing started yet, mark first as in-progress
        let hasAnyActiveOrDone = stepStatuses.contains { status in
            switch status {
                case .pending: return false
                case .inProgress, .completed: return true
            }
        }
        if !hasAnyActiveOrDone, !stepStatuses.isEmpty {
            stepStatuses[0] = .inProgress
            currentStepIndex = 0
        }
        refreshDocTypeTitle()
        updateStepCards()
        openCapture(for: currentStepIndex)
    }
    
    private func openCapture(for index: Int) {
        guard index < steps.count else {
            // Completed flow — navigate to success screen for now
            refreshDocTypeTitle() // Reset to base title when done
            updateStepCards()
            if let vc = STORYBOARD.verifyAccount.instantiateViewController(withIdentifier: "VerifiedScreen") as? VerifiedScreen {
                navigationController?.pushViewController(vc, animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
            return
        }
        
        let step = steps[index]
        let captureVC = IDCaptureVC(documentType: documentType, stepIndex: index, step: step)
        captureVC.onCaptured = { [weak self] image in
            self?.capturedImages[index] = image
        }
        captureVC.onComplete = { [weak self] in
            guard let self else { return }
            // Mark current as completed
            if index < self.stepStatuses.count { self.stepStatuses[index] = .completed }
            // Find the next step that is not completed (skip already-completed steps)
            let nextIndex = self.stepStatuses.enumerated().first(where: { pair in
                let i = pair.offset
                let s = pair.element
                if i <= index { return false }
                if case .completed = s { return false }
                return true
            })?.offset
            if let next = nextIndex {
                self.currentStepIndex = next
                // Only mark as in-progress if not already completed
                if case .completed = self.stepStatuses[next] {
                    // no-op
                } else {
                    self.stepStatuses[next] = .inProgress
                }
            } else {
                // No remaining steps to scan ahead of current; stay or pop back after face
                self.currentStepIndex = min(index + 1, self.stepStatuses.count)
            }
            self.updateStepCards()
            self.refreshDocTypeTitle()
            self.updateBottomButtonsVisibility()
            // If face step, return to steps screen after saving image
            if step.title.lowercased().contains("face") {
                self.navigationController?.popToViewController(self, animated: true)
                return
            }
            // If there is a next non-completed step, auto-advance; otherwise return to steps
            if let next = nextIndex {
                self.openCapture(for: next)
            } else {
                self.navigationController?.popToViewController(self, animated: true)
            }
        }
        navigationController?.pushViewController(captureVC, animated: true)
    }
    
    // MARK: - UI helpers
    private func refreshDocTypeTitle() {
        // While mid-flow, show the current step title (e.g., "Passport Front")
        // After completion or before start, show the base document title.
        if currentStepIndex < steps.count {
            let stepTitle = steps[max(currentStepIndex, 0)].title
            docTypeButton.setTitle(stepTitle, for: .normal)
        } else {
            docTypeButton.setTitle(documentType.title, for: .normal)
        }
    }
    
    // MARK: - Steps UI
    private func buildStepCards() {
        stepCards.removeAll()
        stepsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (idx, step) in steps.enumerated() {
            let card = StepCardView()
            let assetImage = capturedImages[idx] ?? imageForStep(step: step)
            let status = stepStatuses[idx]
            card.configure(stepNumber: idx + 1, title: step.title, image: assetImage, status: status)
            card.tag = idx
            card.addTarget(self, action: #selector(onStepCardTap(_:)), for: .touchUpInside)
            stepCards.append(card)
            stepsStack.addArrangedSubview(card)
        }
    }
    
    private func updateStepCards() {
        if stepCards.count != steps.count {
            buildStepCards()
            return
        }
        for (idx, card) in stepCards.enumerated() {
            let step = steps[idx]
            let previewImage = capturedImages[idx] ?? imageForStep(step: step)
            card.configure(stepNumber: idx + 1, title: step.title, image: previewImage, status: stepStatuses[idx])
            card.tag = idx
        }
        updateBottomButtonsVisibility()
    }
    
    @objc private func onStepCardTap(_ sender: UIControl) {
        let idx = sender.tag
        guard idx < steps.count else { return }
        // Only allow tapping the active step
        switch stepStatuses[idx] {
            case .inProgress:
                currentStepIndex = idx
                refreshDocTypeTitle()
                openCapture(for: idx)
            case .completed:
                // Show preview only from steps screen
                let preview = IDStepPreviewVC(image: capturedImages[idx], stepTitle: steps[idx].title, docTitle: documentType.title)
                preview.onRetake = { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: true)
                    self.currentStepIndex = idx
                    if idx < self.stepStatuses.count { self.stepStatuses[idx] = .inProgress }
                    self.refreshDocTypeTitle()
                    self.updateStepCards()
                    self.openCapture(for: idx)
                }
                preview.onAccept = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                navigationController?.pushViewController(preview, animated: true)
            default:
                return
        }
    }
    
    private func imageForStep(step: IDScanStep) -> UIImage? {
        let lower = step.title.lowercased()
        let isFront = lower.contains("front")
        let isBack = lower.contains("back")
        switch documentType {
            case .driversLicenseOrIDCard:
                if isFront { return UIImage(named: "DRIVER LICENSE - FRONT") }
                if isBack { return UIImage(named: "DRIVER LICENSE - BACK") }
            case .passport:
                if isFront { return UIImage(named: "PASSPORT - FRONT") }
                if isBack { return UIImage(named: "PASSPORT - BACK") }
            case .passportCard:
                if isFront { return UIImage(named: "PASSPORT CARD - FRONT") ?? UIImage(named: "PASSPORT - FRONT") }
                if isBack { return UIImage(named: "PASSPORT CARD - BACK") }
            case .internationalID:
                if isFront { return UIImage(named: "ID CARD - FRONT") }
                if isBack { return UIImage(named: "INTERNATIONAL ID - BACK") }
        }
        if lower.contains("face") { return UIImage(named: "ic_face") ?? UIImage(systemName: "person.crop.circle") }
        return UIImage(named: "drivers-license")
    }
    
    private func labeled(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 22, weight: .heavy)
        l.textColor = .label
        return l
    }
    
    // MARK: - API mapping helpers
    /// Map our `IDDocumentType` to backend `documentType` code.
    /// 1 = Driving License, 2 = Passport, 3 = Passport Card,
    /// 4 = Green Card (not used here), 5 = International ID Card.
    private func apiDocumentTypeCode() -> Int {
        switch documentType {
        case .driversLicenseOrIDCard: return 1
        case .passport: return 2
        case .passportCard: return 3
        case .internationalID: return 5   // no Green Card type in app yet
        }
    }
    
    /// Resolve which captured images correspond to document front, back and face.
    private func resolvedCapturedImages() -> (front: UIImage?, back: UIImage?, live: UIImage?) {
        var front: UIImage?
        var back: UIImage?
        var live: UIImage?
        
        for (idx, step) in steps.enumerated() {
            guard idx < capturedImages.count, let image = capturedImages[idx] else { continue }
            let lower = step.title.lowercased()
            if lower.contains("front") {
                front = image
            } else if lower.contains("back") {
                back = image
            } else if lower.contains("face") {
                live = image
            }
        }
        return (front, back, live)
    }
    
   // Multipart upload: age, documentType, documentFront, documentBack, livePhoto, email.
    private func uploadVerification(documentType: String,
                                    documentFront: Data?,
                                    documentBack: Data?,
                                    livePhoto: Data?,
                                    age: String,
                                    email: String) {
        
        let request = UploadDocumentRequest(age: age, documentType: documentType, email: email)
        
        if Utility.isInternetAvailable() {
            Utility.showIndicator()
            AuthServices.shared.uploadDocument(parameters: request.toJSON(), documentFrontImageData: documentFront, documentBackImageData: documentBack, faceImageData: livePhoto, success: {  [weak self] (statusCode, response) in
                guard let self = self else { return }
                Utility.hideIndicator()

                if let res = response.documentVerificationData {
                    print(res.toJSON())
                    // Navigate to VerifiedScreen with data
                    if let vc = STORYBOARD.verifyAccount.instantiateViewController(withIdentifier: "VerifiedScreen") as? VerifiedScreen {
                        vc.verificationData = res
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }

            }, failure: { [weak self] (error) in
                guard let selfScreen = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: selfScreen, message: error)
                
            })
            
        } else {
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
//    func uploadVerification(documentType: String,
//                            documentFront: Data?,
//                            documentBack: Data?,
//                            livePhoto: Data?,
//                            age: String,
//                            email: String,
//                            completion: @escaping (Result<Data, Error>) -> Void) {
//        
//        // 1) URL
//        guard let url = URL(string: "https://dev.iroidsolutions.com:3035/api/upload") else {
//            completion(.failure(UploadError.invalidURL))
//            return
//        }
//        
//        // 2) Request and headers
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("27a34e6c7fecca9c9d03118a85d18cd81f0b95ad02847725d4c7ae00abeb998f", forHTTPHeaderField: "x-secret-key")
//        
//        // Boundary
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        // Helper to append a field
//        func appendFormField(_ name: String, value: String, to data: inout Data) {
//            data.append("--\(boundary)\r\n")
//            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
//            data.append("\(value)\r\n")
//        }
//        
//        // Helper to append file
//        func appendFileField(_ name: String, filename: String, mimeType: String, fileData: Data, to data: inout Data) {
//            data.append("--\(boundary)\r\n")
//            data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
//            data.append("Content-Type: \(mimeType)\r\n\r\n")
//            data.append(fileData)
//            data.append("\r\n")
//        }
//        
//        // 3) Build body
//        var body = Data()
//        
//        // Text fields
//        appendFormField("age", value: age, to: &body)
//        appendFormField("documentType", value: documentType, to: &body)
//        appendFormField("email", value: email, to: &body)
//        
//        // Files (only add if non-nil)
//        if let front = documentFront {
//            appendFileField("documentFront", filename: "documentFront.jpg", mimeType: "image/jpeg", fileData: front, to: &body)
//        }
//        if let back = documentBack {
//            appendFileField("documentBack", filename: "documentBack.jpg", mimeType: "image/jpeg", fileData: back, to: &body)
//        }
//        if let live = livePhoto {
//            appendFileField("livePhoto", filename: "livePhoto.png", mimeType: "image/png", fileData: live, to: &body)
//        }
//        
//        // final boundary
//        body.append("--\(boundary)--\r\n")
//        
//        request.httpBody = body
//        // optionally set Content-Length (URLSession sets it automatically in most cases)
//        request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
//        
//        // 4) Send request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // Callback on main queue
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                if let http = response as? HTTPURLResponse {
//                    if !(200...299).contains(http.statusCode) {
//                        completion(.failure(UploadError.serverError(statusCode: http.statusCode, data: data)))
//                        return
//                    }
//                }
//                
//                guard let data = data else {
//                    completion(.failure(UploadError.noData))
//                    return
//                }
//                
//                completion(.success(data))
//            }
//        }
//        task.resume()
//    }
    
    // MARK: - Reset
    @objc private func onResetAll() {
        stepStatuses = steps.map { _ in .pending }
        currentStepIndex = 0
        capturedImages = steps.map { _ in nil }
        if !stepStatuses.isEmpty { stepStatuses[0] = .inProgress }
        refreshDocTypeTitle()
        updateStepCards()
    }
    
    private func updateBottomButtonsVisibility() {
        let anyCompleted = stepStatuses.contains { if case .completed = $0 { return true } else { return false } }
        let allCompleted = stepStatuses.count > 0 && stepStatuses.allSatisfy { if case .completed = $0 { return true } else { return false } }
        if allCompleted {
            // Final state: show Submit, hide Continue/Start
            submitButton.isHidden = false
            continueButton.isHidden = true
            startButton.isHidden = true
            resetButton.isHidden = false
        } else if anyCompleted {
            // Mid-flow: show Continue and Reset
            submitButton.isHidden = true
            continueButton.isHidden = false
            startButton.isHidden = true
            resetButton.isHidden = false
        } else {
            // Pre-flow: only Start
            submitButton.isHidden = true
            continueButton.isHidden = true
            startButton.isHidden = false
            resetButton.isHidden = true
        }
    }
}

// MARK: - Step Card View
private final class StepCardView: UIControl {
    private let container = UIView()
    private let imageView = UIImageView()
    private let stepLabel = UILabel()
    private let titleLabel = UILabel()
    private let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let statusIcon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setup() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 20
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray5.cgColor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        // Let the UIControl (self) receive touches
        container.isUserInteractionEnabled = false
        addSubview(container)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        stepLabel.textColor = .systemBlue
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .tertiaryLabel
        chevron.setContentHuggingPriority(.required, for: .horizontal)
        
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        statusIcon.tintColor = .systemGreen
        statusIcon.setContentHuggingPriority(.required, for: .horizontal)
        
        let vLabels = UIStackView(arrangedSubviews: [stepLabel, titleLabel])
        vLabels.axis = .vertical
        vLabels.spacing = 4
        vLabels.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        container.addSubview(vLabels)
        container.addSubview(statusIcon)
        container.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 88),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
            vLabels.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            vLabels.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            vLabels.trailingAnchor.constraint(lessThanOrEqualTo: statusIcon.leadingAnchor, constant: -8),
            
            statusIcon.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -12),
            statusIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        heightAnchor.constraint(equalToConstant: 96).isActive = true
    }
    
    func configure(stepNumber: Int, title: String, image: UIImage?, status: Any) {
        imageView.image = image
        titleLabel.text = title
        apply(status: status, stepNumber: stepNumber)
    }
    
    private func apply(status: Any, stepNumber: Int) {
        guard let status = status as? IDScanStepsVC.StepStatus else { return }
        switch status {
            case .pending:
                container.backgroundColor = UIColor.systemGray6
                container.layer.borderColor = UIColor.systemGray5.cgColor
                alpha = 0.9
                chevron.tintColor = .tertiaryLabel
                stepLabel.text = "Step \(stepNumber)"
                stepLabel.textColor = .systemGray
                statusIcon.isHidden = true
                isUserInteractionEnabled = false
            case .inProgress:
                container.backgroundColor = .systemBackground
                container.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
                alpha = 1.0
                chevron.tintColor = .label
                stepLabel.text = "Step \(stepNumber)"
                stepLabel.textColor = .systemBlue
                statusIcon.isHidden = true
                isUserInteractionEnabled = true
            case .completed:
                container.backgroundColor = .systemBackground
                container.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.6).cgColor
                alpha = 1.0
                chevron.tintColor = .label
                stepLabel.text = "Complete"
                stepLabel.textColor = .systemGreen
                statusIcon.isHidden = false
                // Allow tapping completed card to open preview
                isUserInteractionEnabled = true
        }
    }
}


private extension Data {
    mutating func append(_ string: String) {
        if let d = string.data(using: .utf8) {
            append(d)
        }
    }
}

enum UploadError: Error {
    case invalidURL
    case serverError(statusCode: Int, data: Data?)
    case noData
}
