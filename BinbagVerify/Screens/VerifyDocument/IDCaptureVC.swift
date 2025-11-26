//
//  IDCaptureVC.swift
//  BinbagVerify
//
//  Created by Assistant on 13/11/2025.
//

import UIKit
import AVFoundation
import Vision
import CoreImage

final class IDCaptureVC: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    let documentType: IDDocumentType
    let stepIndex: Int
    let step: IDScanStep
    
    // Advance handler
    var onComplete: (() -> Void)?
    var onCaptured: ((UIImage?) -> Void)?
    
    // Camera
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice?
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let metadataOutput = AVCaptureMetadataOutput()
    private let previewContainer = UIView()
    private let ciContext = CIContext()
    
    // UI
    private let topBar = UIStackView()
    private let backButton = UIButton(type: .system)
    private let torchButton = UIButton(type: .system)
    private let headlineLabel = UILabel()
    private let lowLightLabel = UILabel()
    private let overlayView = UIView()
    private let progressLayer = CAShapeLayer()
    private let bottomStepsStack = UIStackView()
    private var stepButtons: [UIButton] = []
    private let cameraErrorStack = UIStackView()
    private let cameraErrorIcon = UIImageView(image: UIImage(systemName: "camera.fill"))
    private let cameraErrorLabel: UILabel = {
        let l = UILabel()
        l.text = "Can not connect to the camera device"
        l.textColor = .lightText
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    // State
    private var isTorchOn = false
    private var brightnessValue: Double = 1.0
    private var barcodeDetected = false
    private var faceDetected = false
    private var isCapturing = false
    private var goodProgress: CGFloat = 0.0
    private var isAdjustingFocus = true
    private var isAdjustingExposure = true
    private var isReadyToScan = true
    
    // One-time front hint
    private var didPlayFrontHint = false
    private let frontHintContainer = UIView()
    private let frontHintImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private let frontHintScanLine = CAGradientLayer()
    
    // One-time back hint (scan line only)
    private var didPlayBackHint = false
    private let backHintContainer = UIView()
    private let backHintScanLine = CAGradientLayer()
    
    init(documentType: IDDocumentType, stepIndex: Int, step: IDScanStep) {
        self.documentType = documentType
        self.stepIndex = stepIndex
        self.step = step
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTopBar()
        setupBottomBar()
        setupPreviewContainer()
        setupPreview()
        setupOverlay()
        setupFrontHintIfNeeded()
        setupBackHintIfNeeded()
        // No headline in camera layout
        // Gate scanning until hint animation finishes for front/back
        let lower = step.title.lowercased()
        isReadyToScan = !(lower.contains("front") || lower.contains("back"))
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playFrontHintIfNeeded()
        playBackHintIfNeeded()
    }
    
    // MARK: - Camera setup
    private func setupPreview() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        let desiredPosition: AVCaptureDevice.Position = step.title.localizedCaseInsensitiveContains("face") ? .front : .back
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: desiredPosition) {
            videoDevice = device
            if let input = try? AVCaptureDeviceInput(device: device), captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            // Observe focusing/exposure stability
            let options: NSKeyValueObservingOptions = [.new, .initial]
            _ = device.observe(\.isAdjustingFocus, options: options) { [weak self] dev, _ in
                self?.isAdjustingFocus = dev.isAdjustingFocus
            }
            _ = device.observe(\.isAdjustingExposure, options: options) { [weak self] dev, _ in
                self?.isAdjustingExposure = dev.isAdjustingExposure
            }
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        videoOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "video.sample.buffer.queue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Metadata detection for PDF417/back and Face for selfie
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            var types: [AVMetadataObject.ObjectType] = []
            if step.title.localizedCaseInsensitiveContains("back") && documentType != .internationalID {
                types.append(.pdf417)
            }
            if step.title.localizedCaseInsensitiveContains("face") {
                types.append(.face)
            }
            metadataOutput.metadataObjectTypes = types
        }
        
        captureSession.commitConfiguration()
        
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        previewContainer.layer.addSublayer(layer)
        previewLayer = layer
        
        // Mirror selfie
        if desiredPosition == .front {
            layer.connection?.automaticallyAdjustsVideoMirroring = false
            layer.connection?.isVideoMirrored = true
        }
        // Show error UI if camera missing
        cameraErrorStack.isHidden = (videoDevice != nil)
    }
    
    private func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()
        }
        setTorch(false)
    }
    
    // MARK: - UI
    private func setupTopBar() {
        topBar.axis = .horizontal
        topBar.alignment = .center
        topBar.distribution = .fill
        topBar.spacing = 8
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        
        torchButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        torchButton.tintColor = .white
        torchButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.addArrangedSubview(backButton)
        topBar.addArrangedSubview(spacer)
        topBar.addArrangedSubview(torchButton)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    private func setupPreviewContainer() {
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        previewContainer.layer.cornerRadius = 22
        previewContainer.clipsToBounds = true
        view.addSubview(previewContainer)
        
        // Centered error UI
        cameraErrorStack.axis = .vertical
        cameraErrorStack.alignment = .center
        cameraErrorStack.spacing = 16
        cameraErrorStack.translatesAutoresizingMaskIntoConstraints = false
        cameraErrorIcon.tintColor = .lightText
        cameraErrorIcon.contentMode = .scaleAspectFit
        cameraErrorIcon.preferredSymbolConfiguration = .init(pointSize: 48, weight: .regular)
        cameraErrorStack.addArrangedSubview(cameraErrorIcon)
        cameraErrorStack.addArrangedSubview(cameraErrorLabel)
        previewContainer.addSubview(cameraErrorStack)
        
        NSLayoutConstraint.activate([
            previewContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            previewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            previewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            previewContainer.bottomAnchor.constraint(equalTo: bottomStepsStack.topAnchor, constant: -8),
            
            cameraErrorStack.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            cameraErrorStack.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
        ])
    }
    
    private func setupOverlay() {
        // Overlay with cutout over preview
        overlayView.backgroundColor = .clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.isUserInteractionEnabled = false
        previewContainer.addSubview(overlayView)
        
        // Progress ring on cutout
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 6
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        overlayView.layer.addSublayer(progressLayer)
        
        // Low light hint (inside preview)
        lowLightLabel.text = "• need more light"
        lowLightLabel.textColor = .white
        lowLightLabel.alpha = 0.0
        lowLightLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        lowLightLabel.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(lowLightLabel)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: previewContainer.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor),
            
            lowLightLabel.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: -12),
            lowLightLabel.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
        ])
    }
    
    private func setupFrontHintIfNeeded() {
        guard step.title.lowercased().contains("front") else { return }
        frontHintContainer.isUserInteractionEnabled = false
        frontHintContainer.alpha = 0.0
        previewContainer.addSubview(frontHintContainer)
        frontHintContainer.addSubview(frontHintImageView)
        // Apply correct image based on document type and step
        frontHintImageView.image = hintImage() ?? UIImage(named: "drivers-license")
        
        // Gradient scan line
        frontHintScanLine.colors = [
            UIColor.systemGreen.withAlphaComponent(0.0).cgColor,
            UIColor.systemGreen.withAlphaComponent(0.85).cgColor,
            UIColor.systemGreen.withAlphaComponent(0.0).cgColor
        ]
        frontHintScanLine.locations = [0.0, 0.5, 1.0]
        frontHintScanLine.startPoint = CGPoint(x: 0.5, y: 0.0)
        frontHintScanLine.endPoint = CGPoint(x: 0.5, y: 1.0)
        frontHintImageView.layer.addSublayer(frontHintScanLine)
    }
    
    private func setupBackHintIfNeeded() {
        guard step.title.lowercased().contains("back") else { return }
        backHintContainer.isUserInteractionEnabled = false
        backHintContainer.alpha = 0.0
        previewContainer.addSubview(backHintContainer)
        
        // Back hint image based on document type and step
        let backImageView = UIImageView(image: hintImage() ?? UIImage(named: "drivers-license"))
        backImageView.contentMode = .scaleAspectFill
        backImageView.clipsToBounds = true
        backImageView.tag = 9991
        backHintContainer.addSubview(backImageView)
        
        backHintScanLine.colors = [
            UIColor.systemGreen.withAlphaComponent(0.0).cgColor,
            UIColor.systemGreen.withAlphaComponent(0.85).cgColor,
            UIColor.systemGreen.withAlphaComponent(0.0).cgColor
        ]
        backHintScanLine.locations = [0.0, 0.5, 1.0]
        backHintScanLine.startPoint = CGPoint(x: 0.5, y: 0.0)
        backHintScanLine.endPoint = CGPoint(x: 0.5, y: 1.0)
        backHintContainer.layer.addSublayer(backHintScanLine)
    }
    
    private func setupBottomBar() {
        bottomStepsStack.axis = .horizontal
        bottomStepsStack.alignment = .center
        bottomStepsStack.distribution = .equalCentering
        bottomStepsStack.spacing = 8
        bottomStepsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStepsStack)
        
        NSLayoutConstraint.activate([
            bottomStepsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomStepsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomStepsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomStepsStack.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        let steps = documentType.steps
        for idx in 0..<steps.count {
            let title = shortTitle(for: steps[idx].title)
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            btn.setTitleColor(.label, for: .normal)
            btn.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
            btn.layer.cornerRadius = 12
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.systemBlue.cgColor
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            btn.tag = idx
            // Only "Back" step acts as navigation back to steps screen on tap
            if title.lowercased().contains("back") {
                btn.addTarget(self, action: #selector(onBottomBackTap), for: .touchUpInside)
            } else {
                btn.isUserInteractionEnabled = false
            }
            stepButtons.append(btn)
            bottomStepsStack.addArrangedSubview(btn)
            if idx < steps.count - 1 {
                let chevron = UILabel()
                chevron.text = "›"
                chevron.textColor = .label
                chevron.font = .systemFont(ofSize: 22, weight: .semibold)
                bottomStepsStack.addArrangedSubview(chevron)
            }
        }
        updateBottomState()
    }
    
    private func configureHeadline() {
        let stepName = step.title.lowercased()
        let typeName = documentType.title
        headlineLabel.text = "Scan the \(stepName) of the \(typeName)"
    }
    
    private func updateBottomState() {
        for (idx, btn) in stepButtons.enumerated() {
            if idx == stepIndex {
                btn.layer.borderColor = UIColor.systemBlue.cgColor
                btn.backgroundColor = UIColor.systemBackground
            } else if idx < stepIndex {
                btn.layer.borderColor = UIColor.systemGreen.cgColor
                btn.setTitle("✓ " + (btn.title(for: .normal) ?? ""), for: .normal)
                btn.backgroundColor = UIColor.systemBackground
            } else {
                btn.layer.borderColor = UIColor.systemGray4.cgColor
                btn.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.8)
            }
            btn.isEnabled = false
        }
    }
    
    
    private func shortTitle(for full: String) -> String {
        if full.localizedCaseInsensitiveContains("front") { return "Front" }
        if full.localizedCaseInsensitiveContains("back") { return "Back" }
        if full.localizedCaseInsensitiveContains("face") { return "Face" }
        return full.components(separatedBy: " ").first ?? full
    }
    
    // MARK: - Actions
    @objc private func onBack() {
        popToSteps()
    }
    
    private func popToSteps() {
        if let nav = navigationController,
           let stepsVC = nav.viewControllers.first(where: { $0 is IDScanStepsVC }) {
            nav.popToViewController(stepsVC, animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onBottomBackTap() {
        popToSteps()
    }
    
    @objc private func toggleTorch() {
        isTorchOn.toggle()
        setTorch(isTorchOn)
    }
    
    private func setTorch(_ on: Bool) {
        guard let device = videoDevice, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch { }
        torchButton.tintColor = on ? .systemYellow : .white
    }
    
    @objc private func onStepTap(_ sender: UIButton) {
        // Capture only from the active step
        guard sender.tag == stepIndex else { return }
        let settings = AVCapturePhotoSettings()
        if videoDevice?.isFlashAvailable == true {
            settings.flashMode = isTorchOn ? .off : .auto
        }
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Photo delegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()
        var finalImage: UIImage? = nil
        if let data, let ci = CIImage(data: data, options: [.applyOrientationProperty: true]) {
            // For front/back document steps, attempt rectangle detection + perspective correction
            let isFaceStep = step.title.localizedCaseInsensitiveContains("face")
            if !isFaceStep {
                if let rect = detectBestRectangle(in: ci), let corrected = perspectiveCorrect(image: ci, with: rect) {
                    finalImage = corrected
                } else {
                    // Fallback to raw image
                    finalImage = UIImage(data: data)
                }
            } else {
                finalImage = UIImage(data: data)
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isCapturing = false
            self.goodProgress = 0
            self.progressLayer.strokeEnd = 0
            // Report capture back; do not show preview here, do not pop
            self.onCaptured?(finalImage)
            self.onComplete?()
        }
    }
    
    // MARK: - Vision rectangle detection on captured image
    private func detectBestRectangle(in image: CIImage) -> VNRectangleObservation? {
        let request = VNDetectRectanglesRequest()
        request.maximumObservations = 1
        request.minimumSize = 0.3
        request.minimumConfidence = 0.75
        request.minimumAspectRatio = 0.3
        request.quadratureTolerance = 20.0
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
            return (request.results as? [VNRectangleObservation])?.first
        } catch {
            return nil
        }
    }
    
    private func perspectiveCorrect(image: CIImage, with rect: VNRectangleObservation) -> UIImage? {
        // Scale normalized points to image pixels
        let extent = image.extent.size
        func pt(_ p: CGPoint) -> CGPoint { CGPoint(x: p.x * extent.width, y: (1 - p.y) * extent.height) }
        let topLeft = pt(rect.topLeft)
        let topRight = pt(rect.topRight)
        let bottomLeft = pt(rect.bottomLeft)
        let bottomRight = pt(rect.bottomRight)
        
        guard let corrected = CIFilter(name: "CIPerspectiveCorrection", parameters: [
            "inputImage": image,
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight)
        ])?.outputImage else {
            return nil
        }
        guard let cg = ciContext.createCGImage(corrected, from: corrected.extent) else { return nil }
        return UIImage(cgImage: cg, scale: 1.0, orientation: .up)
    }
    
    // MARK: - Video brightness
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Wait until hint animation finishes for front/back
        if !isReadyToScan {
            return
        }
        guard let metadata = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate) as? [CFString: Any],
              let exif = metadata[kCGImagePropertyExifDictionary] as? [CFString: Any],
              let brightness = exif[kCGImagePropertyExifBrightnessValue] as? Double else { return }
        brightnessValue = brightness
        
        let goodLight = brightness > -0.25
        let stable = !(isAdjustingFocus || isAdjustingExposure)
        var conditionOk = goodLight && stable
        if step.title.localizedCaseInsensitiveContains("back") {
            if documentType != .internationalID {
                conditionOk = conditionOk && barcodeDetected
            }
        } else if step.title.localizedCaseInsensitiveContains("face") {
            conditionOk = conditionOk && faceDetected
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.lowLightLabel.alpha = goodLight ? 0.0 : 1.0
            
            // progress animation around cutout
            let delta: CGFloat = conditionOk ? 0.06 : -0.12
            self.goodProgress = max(0, min(1, self.goodProgress + delta))
            self.progressLayer.strokeEnd = self.goodProgress
            
            if self.goodProgress >= 1.0 && !self.isCapturing {
                self.isCapturing = true
                let settings = AVCapturePhotoSettings()
                if self.videoDevice?.isFlashAvailable == true {
                    settings.flashMode = self.isTorchOn ? .off : .auto
                }
                self.photoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }
    
    // MARK: - Metadata (PDF417 / Face)
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var sawBarcode = false
        var sawFace = false
        for obj in metadataObjects {
            if let code = obj as? AVMetadataMachineReadableCodeObject, code.type == .pdf417 {
                sawBarcode = true
            }
            if obj.type == .face {
                sawFace = true
            }
        }
        barcodeDetected = sawBarcode
        faceDetected = sawFace
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = previewContainer.bounds
        drawOverlayCutout()
        layoutFrontHintIfNeeded()
        layoutBackHintIfNeeded()
    }
    
    private func drawOverlayCutout() {
        // Remove previous background shape layers but keep progress if present
        overlayView.layer.sublayers?
            .filter { $0 !== progressLayer }
            .forEach { $0.removeFromSuperlayer() }
        
        let bounds = overlayView.bounds
        let path = UIBezierPath(rect: bounds)
        
        // Decide overlay style by step
        let isFace = step.title.localizedCaseInsensitiveContains("face")
        
        // Compute guide rects
        let insetX: CGFloat = 12
        var guideRect = bounds.insetBy(dx: insetX, dy: insetX)
        
        if isFace {
            // Circular/oval face guide (roughly 70% of overlay height)
            let diameter = min(bounds.width * 0.78, bounds.height * 0.58)
            let x = (bounds.width - diameter) / 2
            let y = (bounds.height - diameter) / 2
            guideRect = CGRect(x: x, y: y, width: diameter, height: diameter)
            let oval = UIBezierPath(ovalIn: guideRect)
            path.append(oval)
            progressLayer.path = oval.cgPath
        } else {
            // Front and Back: same ID card rectangle, ~1.586 aspect
            let width = bounds.width - 32
            let height = min((width / 1.586), bounds.height * 0.75)
            let x = (bounds.width - width) / 2
            let y = (bounds.height - height) / 2
            guideRect = CGRect(x: x, y: y, width: width, height: height)
            let rounded = UIBezierPath(roundedRect: guideRect, cornerRadius: 18)
            path.append(rounded)
            progressLayer.path = rounded.cgPath
        }
        
        path.usesEvenOddFillRule = true
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillRule = .evenOdd
        layer.fillColor = UIColor.black.withAlphaComponent(0.45).cgColor
        overlayView.layer.addSublayer(layer)
        progressLayer.strokeEnd = goodProgress
    }
    
    // MARK: - Front hint placement
    private func layoutFrontHintIfNeeded() {
        guard step.title.lowercased().contains("front") else { return }
        // Place the hint to match the document cutout
        let bounds = overlayView.bounds
        let insetX: CGFloat = 12
        let width = bounds.width - 32
        let height = min((width / 1.586), bounds.height * 0.75)
        let x = (bounds.width - width) / 2
        let y = (bounds.height - height) / 2
        let guideRect = CGRect(x: x, y: y, width: width, height: height)
        let converted = overlayView.convert(guideRect, to: previewContainer)
        
        if frontHintContainer.frame != converted {
            frontHintContainer.frame = converted
            frontHintImageView.frame = frontHintContainer.bounds
            frontHintImageView.layer.cornerRadius = 18
            let lineHeight: CGFloat = 16
            frontHintScanLine.frame = CGRect(x: 0, y: 0, width: frontHintContainer.bounds.width, height: lineHeight)
        }
    }
    
    private func layoutBackHintIfNeeded() {
        guard step.title.lowercased().contains("back") else { return }
        let bounds = overlayView.bounds
        let width = bounds.width - 32
        let height = min((width / 1.586), bounds.height * 0.75)
        let x = (bounds.width - width) / 2
        let y = (bounds.height - height) / 2
        let guideRect = CGRect(x: x, y: y, width: width, height: height)
        let converted = overlayView.convert(guideRect, to: previewContainer)
        
        if backHintContainer.frame != converted {
            backHintContainer.frame = converted
            if let imgView = backHintContainer.viewWithTag(9991) as? UIImageView {
                imgView.frame = backHintContainer.bounds
                imgView.layer.cornerRadius = 18
            }
            let lineHeight: CGFloat = 16
            backHintScanLine.frame = CGRect(x: 0, y: 0, width: backHintContainer.bounds.width, height: lineHeight)
        }
    }
    
    // MARK: - Asset mapping for hint images
    private func hintImage() -> UIImage? {
        // Map by document type and step semantic (front/back)
        let stepLower = step.title.lowercased()
        let isFront = stepLower.contains("front") || stepLower.contains("document front")
        let isBack = stepLower.contains("back")
        
        // Explicit mappings for assets you mentioned
        switch documentType {
            case .driversLicenseOrIDCard:
                if isFront { return UIImage(named: "DRIVER LICENSE - FRONT") }
                if isBack { return UIImage(named: "DRIVER LICENSE - BACK") }
            case .passport:
                // Try a reasonable convention if provided in assets
                if isFront { return UIImage(named: "PASSPORT - FRONT") }
                if isBack { return UIImage(named: "PASSPORT - BACK") }
            case .passportCard:
                if isFront { return UIImage(named: "PASSPORT CARD - FRONT") ?? UIImage(named: "PASSPORT - FRONT") }
                if isBack { return UIImage(named: "PASSPORT CARD - BACK") }
            case .internationalID:
                if isFront { return UIImage(named: "ID CARD - FRONT") }
                if isBack { return UIImage(named: "INTERNATIONAL ID - BACK") }
        }
        return nil
    }
    
    private func playFrontHintIfNeeded() {
        guard step.title.lowercased().contains("front"), !didPlayFrontHint else { return }
        didPlayFrontHint = true
        layoutFrontHintIfNeeded()
        frontHintContainer.alpha = 1.0
        
        // Scan sweep once
        let startY: CGFloat = 0
        let endY: CGFloat = max(0, frontHintContainer.bounds.height - frontHintScanLine.bounds.height)
        let anim = CABasicAnimation(keyPath: "position.y")
        anim.fromValue = startY + frontHintScanLine.bounds.height / 2.0
        anim.toValue = endY + frontHintScanLine.bounds.height / 2.0
        anim.duration = 1.4
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        frontHintScanLine.add(anim, forKey: "onceScan")
        
        // Slight pop to draw attention
        frontHintContainer.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut]) {
            self.frontHintContainer.transform = .identity
        }
        
        // Fade out after sweep completes
        UIView.animate(withDuration: 0.3, delay: 1.5, options: [.curveEaseInOut]) {
            self.frontHintContainer.alpha = 0.0
        } completion: { _ in
            self.frontHintScanLine.removeAllAnimations()
            self.isReadyToScan = true
        }
    }
    
    private func playBackHintIfNeeded() {
        guard step.title.lowercased().contains("back"), !didPlayBackHint else { return }
        didPlayBackHint = true
        layoutBackHintIfNeeded()
        backHintContainer.alpha = 1.0
        
        let startY: CGFloat = 0
        let endY: CGFloat = max(0, backHintContainer.bounds.height - backHintScanLine.bounds.height)
        let anim = CABasicAnimation(keyPath: "position.y")
        anim.fromValue = startY + backHintScanLine.bounds.height / 2.0
        anim.toValue = endY + backHintScanLine.bounds.height / 2.0
        anim.duration = 1.4
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        backHintScanLine.add(anim, forKey: "onceScanBack")
        
        UIView.animate(withDuration: 0.3, delay: 1.5, options: [.curveEaseInOut]) {
            self.backHintContainer.alpha = 0.0
        } completion: { _ in
            self.backHintScanLine.removeAllAnimations()
            self.isReadyToScan = true
        }
    }
}


