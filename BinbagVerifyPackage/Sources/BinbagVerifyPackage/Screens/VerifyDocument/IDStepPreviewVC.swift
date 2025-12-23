//
//  IDStepPreviewVC.swift
//  BinbagVerify
//
//  Created by Assistant on 26/11/2025.
//

import UIKit

final class IDStepPreviewVC: UIViewController {
    
    let image: UIImage?
    let stepTitle: String
    let docTitle: String
    
    var onRetake: (() -> Void)?
    var onAccept: (() -> Void)?
    
    // UI
    private let topBar = UIStackView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let stepNameLabel = UILabel()
    private let docNameLabel = UILabel()
    
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    
    private let retakeButton = UIButton(type: .system)
    private let acceptButton = UIButton(type: .system)
    
    init(image: UIImage?, stepTitle: String, docTitle: String) {
        self.image = image
        self.stepTitle = stepTitle
        self.docTitle = docTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTopBar()
        setupContent()
        setupButtons()
    }
    
    private func setupTopBar() {
        topBar.axis = .horizontal
        topBar.alignment = .center
        topBar.distribution = .fill
        topBar.spacing = 8
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.addArrangedSubview(backButton)
        topBar.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    private func setupContent() {
        titleLabel.text = "Step preview"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        
        stepNameLabel.text = stepTitle
        stepNameLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        stepNameLabel.textAlignment = .center
        
        docNameLabel.text = docTitle
        docNameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        docNameLabel.textColor = .secondaryLabel
        docNameLabel.textAlignment = .center
        
        imageContainer.backgroundColor = .systemBackground
        imageContainer.layer.cornerRadius = 16
        imageContainer.layer.borderColor = UIColor.systemGray5.cgColor
        imageContainer.layer.borderWidth = 1
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageContainer.addSubview(imageView)
        
        let v = UIStackView(arrangedSubviews: [titleLabel, stepNameLabel, docNameLabel, imageContainer])
        v.axis = .vertical
        v.spacing = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            v.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -8),
        ])
    }
    
    private func setupButtons() {
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.backgroundColor = UIColor.systemGray6
        retakeButton.setTitleColor(.label, for: .normal)
        retakeButton.layer.cornerRadius = 8
        retakeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        retakeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        retakeButton.addTarget(self, action: #selector(onRetakeTap), for: .touchUpInside)
        
        acceptButton.setTitle("OK", for: .normal)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.backgroundColor = UIColor.systemBlue
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.layer.cornerRadius = 8
        acceptButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        acceptButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        acceptButton.addTarget(self, action: #selector(onAcceptTap), for: .touchUpInside)
        
        let h = UIStackView(arrangedSubviews: [retakeButton, acceptButton])
        h.axis = .horizontal
        h.spacing = 16
        h.distribution = .fillEqually
        h.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(h)
        
        NSLayoutConstraint.activate([
            h.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            h.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            h.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: - Actions
    @objc private func onBack() {
        onAccept?()
    }
    
    @objc private func onRetakeTap() {
        onRetake?()
    }
    
    @objc private func onAcceptTap() {
        onAccept?()
    }
}


