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

public final class IDCaptureVC: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {

    public let documentType: IDDocumentType
    public let stepIndex: Int
    public let step: IDScanStep

    // Advance handler
    public var onComplete: (() -> Void)?
    public var onCaptured: ((UIImage?) -> Void)?

    // Face-only mode: hides front/back step buttons at bottom
    public var isFaceOnlyMode: Bool = false
    
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
    
    // Liveness
    private enum LivenessStage {
        case center
        case lookLeft
        case lookRight
        case center2
        case done
    }
    private var livenessStage: LivenessStage = .center
    private var livenessPassed = false
    private var livenessLabel = UILabel()
    private var frameCounter = 0
    private var lastLeftEAR: CGFloat = 0.0
    private var lastRightEAR: CGFloat = 0.0
    private var blinkRegistered = false
    private var blinkClosing = false
    private var lastYaw: Float = 0.0
    private var faceQuality: Float = 0.0
    private var brightnessHistory: [Double] = []
    private let maxBrightnessHistory = 40
    // Document rectangle detection (live)
    private var rectDetected = false
    private var rectAspectOK = false
    private var rectFillOK = false
    private var rectAngleOK = false
    private var lastRectObservation: VNRectangleObservation?
    // MRZ detection for passport/international ID back
    private var mrzDetected = false
    private var mrzText: String = ""
    // Rectangle stability + overlay
    private var rectMaskLayer = CAShapeLayer()
    private var rectPolygonPath: UIBezierPath?
    private var lastFiveRectangles: [VNRectangleObservation] = []
    private var lastCapturedRectangle: VNRectangleObservation?
    private var rectStable = false
    // Liveness control
    private var stageFrameCount = 0
    private var wrongFrameCount = 0
    private var missingFaceCount = 0
    private let maxStageFrames = 60          // ~6 seconds (analyze every ~0.1s)
    private let maxWrongFrames = 30          // ~3 seconds of wrong movement
    private let maxMissingFaceFrames = 20    // ~2 seconds without a face
    private var stageHoldCount = 0
    private let holdFramesCenter = 5         // ~0.5s dwell in center
    private let holdFramesTurn = 5           // ~0.5s dwell on each side
    private var faceCentered = false
    
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
    
    public init(documentType: IDDocumentType, stepIndex: Int, step: IDScanStep) {
        self.documentType = documentType
        self.stepIndex = stepIndex
        self.step = step
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) { nil }
    
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
		if step.title.localizedCaseInsensitiveContains("face") {
            livenessStage = .center
            livenessPassed = false
            blinkRegistered = false
            updateLivenessLabel("center your face")
            livenessLabel.alpha = 1.0
            stageFrameCount = 0
            wrongFrameCount = 0
            missingFaceCount = 0
        }
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
            let stepLower = step.title.lowercased()
            if stepLower.contains("back") {
                // Driver's license and passport card backs have PDF417 barcodes
                if documentType == .driversLicenseOrIDCard || documentType == .passportCard {
                    types.append(.pdf417)
                }
                // Passport and international ID backs do NOT require barcode - they use MRZ (text)
                // MRZ is detected via Vision text recognition, not AVMetadata
            }
            if stepLower.contains("face") {
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
        
        // Liveness guidance
        livenessLabel.text = ""
        livenessLabel.textColor = .white
        livenessLabel.alpha = 0.0
        livenessLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        livenessLabel.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(livenessLabel)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: previewContainer.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor),
            
            lowLightLabel.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: -12),
            lowLightLabel.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            
            livenessLabel.bottomAnchor.constraint(equalTo: lowLightLabel.topAnchor, constant: -8),
            livenessLabel.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
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

        // In face-only mode, hide all step buttons (front/back)
        if isFaceOnlyMode {
            bottomStepsStack.isHidden = true
            return
        }

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

        if let data {
            // First create UIImage to get proper orientation from EXIF
            guard let originalUIImage = UIImage(data: data) else {
                DispatchQueue.main.async { [weak self] in
                    self?.isCapturing = false
                    self?.goodProgress = 0
                    self?.progressLayer.strokeEnd = 0
                    self?.onCaptured?(nil)
                    self?.onComplete?()
                }
                return
            }

            // Normalize image orientation - render with correct orientation applied
            let normalizedImage = normalizeImageOrientation(originalUIImage)

            let isFaceStep = step.title.localizedCaseInsensitiveContains("face")
            
            if isFaceStep {
                // Selfie: keep the full frame and mirror horizontally so
                // the preview matches what the user saw in the live camera.
                finalImage = mirrorImageHorizontally(normalizedImage)
            } else {
                // Document front/back: crop to detected rectangle area (no warp),
                // so preview shows only the ID card area, same orientation
                // as the live capture.
                if let cgImage = normalizedImage.cgImage {
                    let ci = CIImage(cgImage: cgImage)
                    if let rect = detectBestRectangle(in: ci),
                       let cropped = cropRectangle(image: ci, rect: rect, padding: 0.10) {
                        finalImage = cropped
                    } else {
                        // Fallback to full normalized image if detection fails
                        finalImage = normalizedImage
                    }
                } else {
                    finalImage = normalizedImage
                }
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

    /// Normalize image orientation by rendering it with the correct transform applied
    private func normalizeImageOrientation(_ image: UIImage) -> UIImage {
        // If already up, no need to process
        if image.imageOrientation == .up {
            return image
        }

        // Draw image with correct orientation
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? image
    }
    
    /// Mirror image horizontally (left/right flip) so selfies look the same
    /// as the mirrored live preview.
    private func mirrorImageHorizontally(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return image
        }
        ctx.translateBy(x: image.size.width, y: 0)
        ctx.scaleBy(x: -1, y: 1)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let mirrored = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mirrored ?? image
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
    
    // MARK: - Vision face detection on captured image (for cropping)
    private func detectBestFace(in image: CIImage) -> VNFaceObservation? {
        let req = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([req])
            return (req.results as? [VNFaceObservation])?.first
        } catch {
            return nil
        }
    }
    
    private func cropFace(image: CIImage, face: VNFaceObservation, padding: CGFloat) -> UIImage? {
        return cropNormalizedBoundingBox(image: image, box: face.boundingBox, padding: padding)
    }
    
    /// Generic crop helper for Vision normalized bounding boxes (origin at lower-left).
    private func cropNormalizedBoundingBox(image: CIImage, box: CGRect, padding: CGFloat) -> UIImage? {
        let extent = image.extent
        // Convert normalized rect (0–1, origin at lower-left) into pixel space of CIImage.
        var x = box.origin.x * extent.width
        var y = box.origin.y * extent.height
        var w = box.size.width * extent.width
        var h = box.size.height * extent.height
        
        // Optional padding around the box
        let padX = padding * w
        let padY = padding * h
        x -= padX
        y -= padY
        w += 2 * padX
        h += 2 * padY
        
        var cropRect = CGRect(x: x, y: y, width: w, height: h)
        cropRect = cropRect.intersection(extent)
        guard !cropRect.isNull, cropRect.width > 10, cropRect.height > 10 else { return nil }
        
        let cropped = image.cropped(to: cropRect)
        guard let cg = ciContext.createCGImage(cropped, from: cropped.extent) else { return nil }
        return UIImage(cgImage: cg, scale: 1.0, orientation: .up)
    }
    
    /// Crop document to its detected rectangle bounding box (no perspective warp).
    private func cropRectangle(image: CIImage, rect: VNRectangleObservation, padding: CGFloat) -> UIImage? {
        return cropNormalizedBoundingBox(image: image, box: rect.boundingBox, padding: padding)
    }
    
    private func perspectiveCorrect(image: CIImage, with rect: VNRectangleObservation) -> UIImage? {
        // CIImage from CGImage has origin at top-left (unlike raw CIImage which is bottom-left)
        // Vision coordinates are normalized with origin at bottom-left
        let extent = image.extent
        let width = extent.width
        let height = extent.height

        // Convert Vision normalized coordinates to CIImage pixel coordinates
        // Since we're using CIImage from CGImage, Y is already flipped
        func pt(_ p: CGPoint) -> CGPoint {
            return CGPoint(x: p.x * width + extent.origin.x,
                           y: (1.0 - p.y) * height + extent.origin.y)
        }

        // Map Vision corners to pixel coordinates
        let topLeft = pt(rect.topLeft)
        let topRight = pt(rect.topRight)
        let bottomLeft = pt(rect.bottomLeft)
        let bottomRight = pt(rect.bottomRight)

        // CIPerspectiveCorrection expects corners in CIImage coordinate space
        // inputTopLeft should be the corner that will become top-left in output
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
        brightnessHistory.append(brightness)
        if brightnessHistory.count > maxBrightnessHistory {
            brightnessHistory.removeFirst(brightnessHistory.count - maxBrightnessHistory)
        }
        
        // TEMP: disable strict light validation for now
        let goodLight = true
        let stable = !(isAdjustingFocus || isAdjustingExposure)
        var conditionOk = stable
        
        let stepLower = step.title.lowercased()
        frameCounter &+= 1
        if stepLower.contains("face") {
            if frameCounter % 2 == 0 {
                analyzeFaceForLiveness(sampleBuffer)
            }
            let brightnessStd = brightnessStdDev()
            let qualityOK = faceQuality == 0 ? true : (faceQuality >= 0.45)
            let spoofRiskLow = qualityOK && brightnessStd >= 0.06
            conditionOk = conditionOk && livenessPassed && spoofRiskLow
        } else {
            // Front / Back document: require a good rectangle presence
            if frameCounter % 2 == 0 {
                analyzeDocumentRectangle(sampleBuffer)
            }
            // Also check for MRZ on passport/international ID back
            if frameCounter % 3 == 0 && stepLower.contains("back") {
                if documentType == .passport || documentType == .internationalID {
                    analyzeMRZ(sampleBuffer)
                }
            }
            let rectOK = rectDetected && rectAspectOK && rectFillOK && rectAngleOK && rectStable
            if stepLower.contains("back") {
                // Driver's license and passport card: require PDF417 barcode
                if documentType == .driversLicenseOrIDCard || documentType == .passportCard {
                    conditionOk = conditionOk && rectOK && barcodeDetected
                } else if documentType == .passport || documentType == .internationalID {
                    // Passport and international ID: require MRZ detection
                    conditionOk = conditionOk && rectOK && mrzDetected
                }
            } else {
                // Front sides: just need good rectangle
                conditionOk = conditionOk && rectOK
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.lowLightLabel.alpha = goodLight ? 0.0 : 1.0
            if self.step.title.localizedCaseInsensitiveContains("face") {
                self.livenessLabel.alpha = 1.0
            }
            
            // progress animation around cutout - faster fill rate for quicker capture
            let delta: CGFloat = conditionOk ? 0.12 : -0.08    // Was 0.06 / -0.12
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
    
    // MARK: - Vision liveness (Face)
    private func analyzeFaceForLiveness(_ sampleBuffer: CMSampleBuffer) {
        guard step.title.localizedCaseInsensitiveContains("face"),
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let orientation = cgImageOrientationForCurrentVideo()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:])
        
        let landmarksReq = VNDetectFaceLandmarksRequest()
        let qualityReq = VNDetectFaceCaptureQualityRequest()
        
        do {
            try handler.perform([landmarksReq, qualityReq])
        } catch {
            return
        }
        
        if let obs = (landmarksReq.results as? [VNFaceObservation])?.first {
            faceDetected = true
            missingFaceCount = 0
            // Update centeredness in normalized image space
            let cx = obs.boundingBox.midX
            faceCentered = abs(CGFloat(cx) - 0.5) <= 0.10
            
            // Update capture quality if provided
            if let q = obs.faceCaptureQuality {
                faceQuality = q
            } else if let q2 = (qualityReq.results as? [VNFaceObservation])?.first?.faceCaptureQuality {
                faceQuality = q2
            }
            
            // Head yaw (radians). Positive ~ turn right, Negative ~ turn left.
            if let yaw = obs.yaw?.floatValue {
                lastYaw = yaw
            }
            
            // Blink detection via eye opening ratio (bounding box height/width) on both eyes
            var leftEAR: CGFloat = lastLeftEAR
            var rightEAR: CGFloat = lastRightEAR
            if let lm = obs.landmarks {
                if let l = lm.leftEye?.normalizedPoints {
                    leftEAR = eyeOpenRatio(points: l)
                }
                if let r = lm.rightEye?.normalizedPoints {
                    rightEAR = eyeOpenRatio(points: r)
                }
            }
            let ear = min(leftEAR, rightEAR)
            // Simple state machine: detect close then re-open
            let closeThresh: CGFloat = 0.14
            let openThresh: CGFloat = 0.22
            if !blinkRegistered {
                if !blinkClosing {
                    if ear < closeThresh {
                        blinkClosing = true
                    }
                } else {
                    if ear > openThresh {
                        blinkRegistered = true
                        blinkClosing = false
                    }
                }
            }
            // Smooth last EARs a bit to reduce jitter
            lastLeftEAR = lastLeftEAR * 0.6 + leftEAR * 0.4
            lastRightEAR = lastRightEAR * 0.6 + rightEAR * 0.4
            
            // Advance liveness stages
            advanceLivenessIfNeeded(yaw: lastYaw)
        } else {
            faceDetected = false
            missingFaceCount += 1
            if missingFaceCount > maxMissingFaceFrames {
                resetLiveness()
            }
        }
    }
    
    private func advanceLivenessIfNeeded(yaw: Float) {
        // Tolerances
        let centerTol: Float = 0.15
        let leftThresh: Float = -0.35
        let rightThresh: Float = 0.35
        
        // Match UI directions for mirrored selfie preview
        let mirrored = previewLayer?.connection?.isVideoMirrored == true
        let y = mirrored ? -yaw : yaw
        
        stageFrameCount &+= 1
        if stageFrameCount > maxStageFrames || wrongFrameCount > maxWrongFrames {
            resetLiveness()
            return
        }
        
        switch livenessStage {
        case .center:
            if abs(y) <= centerTol && faceCentered {
                stageHoldCount &+= 1
                if stageHoldCount >= holdFramesCenter {
                    // Move to left first per requirement
                    livenessStage = .lookLeft
                    stageFrameCount = 0
                    stageHoldCount = 0
                    wrongFrameCount = 0
                    DispatchQueue.main.async { self.updateLivenessLabel("<< turn head left") }
                } else {
                    DispatchQueue.main.async { self.updateLivenessLabel("center your face") }
                }
            } else {
                stageHoldCount = 0
                DispatchQueue.main.async { self.updateLivenessLabel("center your face") }
            }
        case .lookLeft:
            if y <= leftThresh {
                stageHoldCount &+= 1
                if stageHoldCount >= holdFramesTurn {
                    livenessStage = .lookRight
                    stageFrameCount = 0
                    stageHoldCount = 0
                    wrongFrameCount = 0
                    DispatchQueue.main.async { self.updateLivenessLabel("turn head right >>") }
                } else {
                    DispatchQueue.main.async { self.updateLivenessLabel("<< turn head left") }
                }
            } else {
                if y >= rightThresh { wrongFrameCount &+= 1 }
                stageHoldCount = 0
                DispatchQueue.main.async { self.updateLivenessLabel("<< turn head left") }
            }
        case .lookRight:
            if y >= rightThresh {
                stageHoldCount &+= 1
                if stageHoldCount >= holdFramesTurn {
                    livenessStage = .center2
                    stageFrameCount = 0
                    stageHoldCount = 0
                    wrongFrameCount = 0
                    DispatchQueue.main.async { self.updateLivenessLabel("center your face") }
                } else {
                    DispatchQueue.main.async { self.updateLivenessLabel("turn head right >>") }
                }
            } else {
                if y <= leftThresh { wrongFrameCount &+= 1 }
                stageHoldCount = 0
                DispatchQueue.main.async { self.updateLivenessLabel("turn head right >>") }
            }
        case .center2:
            if abs(y) <= centerTol && faceCentered {
                stageHoldCount &+= 1
                if stageHoldCount >= holdFramesCenter {
                    livenessStage = .done
                    livenessPassed = true
                    DispatchQueue.main.async {
                        self.updateLivenessLabel("all good")
                        // Immediate capture once liveness finishes
                        if !self.isCapturing {
                            self.isCapturing = true
                            let settings = AVCapturePhotoSettings()
                            if self.videoDevice?.isFlashAvailable == true {
                                settings.flashMode = self.isTorchOn ? .off : .auto
                            }
                            self.photoOutput.capturePhoto(with: settings, delegate: self)
                        }
                    }
                } else {
                    DispatchQueue.main.async { self.updateLivenessLabel("center your face") }
                }
            } else {
                stageHoldCount = 0
                DispatchQueue.main.async { self.updateLivenessLabel("center your face") }
            }
        case .done:
            DispatchQueue.main.async { self.updateLivenessLabel("all good") }
        }
    }
    
    private func resetLiveness() {
        livenessStage = .center
        livenessPassed = false
        blinkRegistered = false
        blinkClosing = false
        stageFrameCount = 0
        wrongFrameCount = 0
        updateLivenessLabel("center your face")
    }
    
    private func updateLivenessLabel(_ text: String) {
        // Keep it very short and actionable; ensure main-thread UI update
        if Thread.isMainThread {
            //livenessLabel.text = "• " + text
            livenessLabel.text = text
        } else {
            DispatchQueue.main.async { [weak self] in
               // self?.livenessLabel.text = "• " + text
                self?.livenessLabel.text = text
            }
        }
    }
    
    private func brightnessStdDev() -> Double {
        guard brightnessHistory.count >= 8 else { return 0 }
        let mean = brightnessHistory.reduce(0, +) / Double(brightnessHistory.count)
        let variance = brightnessHistory.reduce(0) { $0 + pow($1 - mean, 2) } / Double(brightnessHistory.count)
        return sqrt(variance)
    }
    
    private func cgImageOrientationForCurrentVideo() -> CGImagePropertyOrientation {
        // Default to portrait
        if let connection = previewLayer?.connection {
            switch connection.videoOrientation {
            case .portrait: return .right
            case .portraitUpsideDown: return .left
            case .landscapeLeft: return .up
            case .landscapeRight: return .down
            @unknown default: return .right
            }
        }
        return .right
    }
    
    // MARK: - Rectangle overlay & stability (ported from ScanCardsScreen)
    private func animatePreviewLayer(opacity: Float, duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        previewLayer?.opacity = opacity
        CATransaction.commit()
    }
    
    private func isRectangleSimilar(_ rect1: VNRectangleObservation, to rect2: VNRectangleObservation?) -> Bool {
        guard let rect2 = rect2, let layer = previewLayer else { return false }
        let layerBounds = layer.bounds
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -layerBounds.height)
        let scale = CGAffineTransform.identity.scaledBy(x: layerBounds.width, y: layerBounds.height)
        
        let topLeft = rect1.topLeft.applying(scale).applying(transform)
        let topRight = rect1.topRight.applying(scale).applying(transform)
        let bottomLeft = rect1.bottomLeft.applying(scale).applying(transform)
        let bottomRight = rect1.bottomRight.applying(scale).applying(transform)
        let RtopLeft = rect2.topLeft.applying(scale).applying(transform)
        let RtopRight = rect2.topRight.applying(scale).applying(transform)
        let RbottomLeft = rect2.bottomLeft.applying(scale).applying(transform)
        let RbottomRight = rect2.bottomRight.applying(scale).applying(transform)
        let threshold: CGFloat = 10.0
        let topLeftClose = (abs(topLeft.x - RtopLeft.x) < threshold) && (abs(topLeft.y - RtopLeft.y) < threshold)
        let topRightClose = (abs(topRight.x - RtopRight.x) < threshold) && (abs(topRight.y - RtopRight.y) < threshold)
        let bottomLeftClose = (abs(bottomLeft.x - RbottomLeft.x) < threshold) && (abs(bottomLeft.y - RbottomLeft.y) < threshold)
        let bottomRightClose = (abs(bottomRight.x - RbottomRight.x) < threshold) && (abs(bottomRight.y - RbottomRight.y) < threshold)
        return topLeftClose && topRightClose && bottomLeftClose && bottomRightClose
    }
    
    private func isRectangleStable(_ rect: VNRectangleObservation, with referenceRect: VNRectangleObservation) -> Bool {
        guard let layer = previewLayer else { return false }
        let layerBounds = layer.bounds
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -layerBounds.height)
        let scale = CGAffineTransform.identity.scaledBy(x: layerBounds.width, y: layerBounds.height)

        let topLeft = rect.topLeft.applying(scale).applying(transform)
        let topRight = rect.topRight.applying(scale).applying(transform)
        let bottomLeft = rect.bottomLeft.applying(scale).applying(transform)
        let bottomRight = rect.bottomRight.applying(scale).applying(transform)
        let RtopLeft = referenceRect.topLeft.applying(scale).applying(transform)
        let RtopRight = referenceRect.topRight.applying(scale).applying(transform)
        let RbottomLeft = referenceRect.bottomLeft.applying(scale).applying(transform)
        let RbottomRight = referenceRect.bottomRight.applying(scale).applying(transform)

        // More lenient threshold for stability (was 2.0)
        let threshold: CGFloat = 8.0
        let topLeftClose = (abs(topLeft.x - RtopLeft.x) < threshold) && (abs(topLeft.y - RtopLeft.y) < threshold)
        let topRightClose = (abs(topRight.x - RtopRight.x) < threshold) && (abs(topRight.y - RtopRight.y) < threshold)
        let bottomLeftClose = (abs(bottomLeft.x - RbottomLeft.x) < threshold) && (abs(bottomLeft.y - RbottomLeft.y) < threshold)
        let bottomRightClose = (abs(bottomRight.x - RbottomRight.x) < threshold) && (abs(bottomRight.y - RbottomRight.y) < threshold)

        return topLeftClose && topRightClose && bottomLeftClose && bottomRightClose
    }
    
    private func drawBoundingBox(rect: VNRectangleObservation) {
        guard let layer = previewLayer else { return }
        let offsetY: CGFloat = 0
        let transform = CGAffineTransform(translationX: 0, y: offsetY).scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -layer.bounds.height)
        let scale = CGAffineTransform.identity.scaledBy(x: layer.bounds.width, y: layer.bounds.height)
        
        let topLeft = rect.topLeft.applying(scale).applying(transform)
        let topRight = rect.topRight.applying(scale).applying(transform)
        let bottomLeft = rect.bottomLeft.applying(scale).applying(transform)
        let bottomRight = rect.bottomRight.applying(scale).applying(transform)
        
        createPolygon(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
    }
    
    private func createPolygon(topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        rectPolygonPath = path
        
        // Reuse a single layer: update path each time, insert once
        if rectMaskLayer.superlayer == nil {
            rectMaskLayer.fillColor = UIColor.clear.cgColor
            rectMaskLayer.strokeColor = UIColor.systemBlue.cgColor
            rectMaskLayer.lineWidth = 2.0
            if let layer = previewLayer {
                layer.insertSublayer(rectMaskLayer, at: 1)
            }
        }
        
        // Animate path update slightly
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.10)
        rectMaskLayer.path = path.cgPath
        CATransaction.commit()
    }
    
    private func removeRectMask() {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = 0.25
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fadeOutAnimation.isRemovedOnCompletion = false
        fadeOutAnimation.fillMode = .forwards
        rectMaskLayer.add(fadeOutAnimation, forKey: "opacity")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) { [weak self] in
            self?.rectMaskLayer.removeFromSuperlayer()
        }
    }
    
    // MARK: - MRZ Detection for passport/international ID
    private func analyzeMRZ(_ sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            mrzDetected = false
            return
        }

        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self, error == nil,
                  let observations = request.results as? [VNRecognizedTextObservation] else {
                self?.mrzDetected = false
                return
            }

            // Look for MRZ patterns in recognized text
            // MRZ lines typically start with specific patterns and contain < characters
            var foundMRZ = false
            var mrzLines: [String] = []

            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let text = candidate.string.uppercased()

                // MRZ characteristics (relaxed for faster detection):
                // - Contains < characters (filler)
                // - Has mostly uppercase letters and digits
                // - Reasonable length
                let chevronCount = text.filter { $0 == "<" }.count
                let alphanumCount = text.filter { $0.isLetter || $0.isNumber }.count
                let ratio = Double(alphanumCount + chevronCount) / max(1, Double(text.count))

                // Relaxed MRZ detection - fewer chevrons required, shorter text OK
                if chevronCount >= 1 && ratio > 0.75 && text.count >= 15 {
                    foundMRZ = true
                    mrzLines.append(text)
                }

                // Also check for specific MRZ start patterns
                if text.hasPrefix("P<") || text.hasPrefix("P ") || text.hasPrefix("I<") ||
                   text.hasPrefix("ID") || text.hasPrefix("A<") || text.hasPrefix("C<") ||
                   text.hasPrefix("V<") || text.contains("<<<") {
                    foundMRZ = true
                    if !mrzLines.contains(text) {
                        mrzLines.append(text)
                    }
                }
            }

            self.mrzDetected = foundMRZ
            self.mrzText = mrzLines.joined(separator: "\n")
        }

        // Configure for MRZ recognition - use fast mode for quicker detection
        request.recognitionLevel = .fast              // Was .accurate - much faster
        request.usesLanguageCorrection = false
        request.recognitionLanguages = ["en-US"]
        // Focus on bottom portion of document where MRZ typically appears
        request.regionOfInterest = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.6)

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: cgImageOrientationForCurrentVideo(),
                                            options: [:])
        do {
            try handler.perform([request])
        } catch {
            mrzDetected = false
        }
    }

    // MARK: - Vision rectangle detection (Front/Back live)
    private func analyzeDocumentRectangle(_ sampleBuffer: CMSampleBuffer) {
        guard !step.title.localizedCaseInsensitiveContains("face"),
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let req = VNDetectRectanglesRequest()
        req.maximumObservations = 1
        // Relaxed parameters for faster detection
        req.minimumSize = 0.10                    // Allow smaller documents (was 0.15)
        req.minimumConfidence = 0.60              // Lower confidence threshold (was 0.80)
        req.minimumAspectRatio = 0.20             // Slightly more tolerant (was 0.10)
        req.quadratureTolerance = 30.0            // More angle tolerance (was 20.0)
        // Wider region of interest for easier positioning
        let roiW: CGFloat = 0.85                  // Was 0.72
        let roiH: CGFloat = 0.85                  // Was 0.72
        let roiX: CGFloat = (1.0 - roiW) * 0.5
        let roiY: CGFloat = (1.0 - roiH) * 0.5
        req.regionOfInterest = CGRect(x: roiX, y: roiY, width: roiW, height: roiH)
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: cgImageOrientationForCurrentVideo(),
                                            options: [:])
        do {
            try handler.perform([req])
        } catch {
            rectDetected = false
            rectAspectOK = false
            rectFillOK = false
            rectAngleOK = false
            lastRectObservation = nil
            rectStable = false
            lastFiveRectangles.removeAll(keepingCapacity: true)
            removeRectMask()
            return
        }
        
        guard let obs = (req.results as? [VNRectangleObservation])?.first else {
            rectDetected = false
            rectAspectOK = false
            rectFillOK = false
            rectAngleOK = false
            lastRectObservation = nil
            rectStable = false
            lastFiveRectangles.removeAll(keepingCapacity: true)
            removeRectMask()
            return
        }
        
        lastRectObservation = obs
        // Draw polygon overlay for user feedback
        drawBoundingBox(rect: obs)
        
        // Track stability across recent frames (reduced from 5 to 3 for faster capture)
        lastFiveRectangles.append(obs)
        if lastFiveRectangles.count > 3 {
            lastFiveRectangles.removeFirst()
        }
        var stableNow = false
        if lastFiveRectangles.count >= 3 {
            stableNow = lastFiveRectangles.allSatisfy { isRectangleStable($0, with: lastFiveRectangles[0]) }
            if stableNow {
                if lastCapturedRectangle == nil || !isRectangleSimilar(lastCapturedRectangle!, to: obs) {
                    lastCapturedRectangle = obs
                }
            }
        }
        rectStable = stableNow

        // Evaluate fitness
        evaluateRectangleFitness(obs)
        // Require stability only when we have enough frames
        if lastFiveRectangles.count >= 3 {
            rectDetected = rectDetected && stableNow
        }
    }
    
    private func evaluateRectangleFitness(_ rect: VNRectangleObservation) {
        // Bounding box geometry in normalized coordinates
        let r = rect.boundingBox
        let w = max(r.width, 1e-6)
        let h = max(r.height, 1e-6)
        let ratio = max(w, h) / min(w, h) // orientation-agnostic
        
        // ID card typical aspect ~ 1.586 (85.6x54mm). Very generous tolerance for all document types.
        rectAspectOK = (ratio >= 1.10 && ratio <= 2.50)      // Was 1.25-2.10

        // Size / fill: allow wider range of document sizes
        let area = w * h
        rectFillOK = (area >= 0.05 && area <= 0.90)          // Was 0.08-0.80

        // Centering: more lenient positioning
        let centerDx = abs((r.origin.x + r.size.width * 0.5) - 0.5)
        let centerDy = abs((r.origin.y + r.size.height * 0.5) - 0.5)
        let centerOK = (centerDx <= 0.30 && centerDy <= 0.30) // Was 0.20, 0.22
        
        // Angle: use top edge vector
        func angleDeg(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
            let vx = b.x - a.x
            let vy = b.y - a.y
            let ang = atan2(vy, vx) * 180.0 / .pi
            return abs(ang)
        }
        let topAngle = angleDeg(rect.topLeft, rect.topRight)
        let bottomAngle = angleDeg(rect.bottomLeft, rect.bottomRight)
        // Accept if either edge is close-ish to horizontal (more tolerant)
        rectAngleOK = (min(topAngle, bottomAngle) <= 35.0)    // Was 22.0
        
        rectDetected = centerOK && rectAspectOK && rectFillOK && rectAngleOK
    }
    
    private func eyeOpenRatio(points: [CGPoint]) -> CGFloat {
        // Robust openness metric: eye bbox height / width, independent of point ordering
        guard !points.isEmpty else { return 0.3 }
        var minX = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude
        for p in points {
            if p.x < minX { minX = p.x }
            if p.x > maxX { maxX = p.x }
            if p.y < minY { minY = p.y }
            if p.y > maxY { maxY = p.y }
        }
        let width = max(maxX - minX, 1e-5)
        let height = maxY - minY
        let ratio = height / width
        return max(0, min(1, ratio))
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
        let isFront = stepLower.contains("front")
        let isBack = stepLower.contains("back")

        // Explicit mappings for assets - with fallbacks
        switch documentType {
            case .driversLicenseOrIDCard:
                if isFront { return UIImage(named: "DRIVER LICENSE - FRONT") ?? UIImage(named: "drivers-license") }
                if isBack { return UIImage(named: "DRIVER LICENSE - BACK") ?? UIImage(named: "drivers-license") }
            case .passport:
                // Passport uses same image asset for front; back may use front flipped or a generic
                if isFront { return UIImage(named: "PASSPORT - FRONT") }
                if isBack { return UIImage(named: "PASSPORT - BACK") ?? UIImage(named: "PASSPORT - FRONT") }
            case .passportCard:
                if isFront { return UIImage(named: "PASSPORT CARD - FRONT") ?? UIImage(named: "PASSPORT - FRONT") }
                if isBack { return UIImage(named: "PASSPORT CARD - BACK") ?? UIImage(named: "PASSPORT - FRONT") }
            case .internationalID:
                if isFront { return UIImage(named: "ID CARD - FRONT") ?? UIImage(named: "DRIVER LICENSE - FRONT") }
                if isBack { return UIImage(named: "INTERNATIONAL ID - BACK") ?? UIImage(named: "DRIVER LICENSE - BACK") }
        }
        return UIImage(named: "drivers-license")
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


