//
//  VerifiedScreen.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 08/10/24.
//

import UIKit

class VerifiedScreen: UIViewController {

    // Data passed from IDScanStepsVC
    var verificationData: DocumentVerificationData?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Verification Result"
        setupUI()
        displayVerificationResult()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func displayVerificationResult() {
        guard let data = verificationData else {
            addSectionHeader("No Data")
            return
        }

        // Request ID
        if let requestId = data.requestId {
            addSectionHeader("Request Info")
            addRow("Request ID", value: "\(requestId)")
        }

        // Document Info
        if let document = data.diveResponse?.document {
            addSectionHeader("Document Information")
            addRow("Full Name", value: document.fullName)
            addRow("First Name", value: document.firstName)
            addRow("Family Name", value: document.familyName)
            addRow("Middle Name", value: document.middleName)
            addRow("Date of Birth", value: document.dob)
            addRow("Gender", value: document.gender)
            addRow("Address", value: document.address)
            addRow("City", value: document.city)
            addRow("State", value: document.state)
            addRow("Zip", value: document.zip)
            addRow("Country", value: document.country)
            addRow("ID Number", value: document.id)
            addRow("ID Type", value: document.idType)
            addRow("Document Class", value: document.documentClass)
            addRow("Issued", value: document.issued)
            addRow("Issued By", value: document.issuedBy)
            addRow("Expires", value: document.expires)
            addRow("Eyes", value: document.eyes)
            addRow("Hair", value: document.hair)
            addRow("Height", value: document.height)
            addRow("Weight", value: document.weight)
        }

        // Document Verification Result
        if let docResult = data.diveResponse?.documentVerificationResult {
            addSectionHeader("Document Verification")
            addRow("Document Expired", value: boolString(docResult.isDocumentExpired))
            addRow("OCR Success", value: boolString(docResult.isOcrSuccess))
            addRow("PDF417 Success", value: boolString(docResult.isPdf417Success))
            addRow("MRZ Success", value: boolString(docResult.isMrzSuccess))
            addRow("Document Confidence", value: docResult.documentConfidence != nil ? "\(docResult.documentConfidence!)%" : nil)
            addRow("Real ID", value: boolString(docResult.isDriversLicenseRealID))
            addRow("Commercial DL", value: boolString(docResult.isCommercialDriversLicense))
            addRow("Veteran", value: boolString(docResult.isVeteran))
            addRow("Donor", value: boolString(docResult.isDonor))
        }

        // Face Match Result
        if let faceMatch = data.diveResponse?.faceMatchVerificationResult {
            addSectionHeader("Face Match Verification")
            addRow("Face Match Confidence", value: faceMatch.faceMatchConfidence != nil ? "\(faceMatch.faceMatchConfidence!)%" : nil)
            addRow("Age Check Success", value: boolString(faceMatch.isAgeCheckSuccess))
            addRow("Gender Check Success", value: boolString(faceMatch.isGenderCheckSuccess))
            addRow("Age from Selfie", value: faceMatch.assessedAgeFromSelfie != nil ? "\(faceMatch.assessedAgeFromSelfie!)" : nil)
            addRow("Age from Document", value: faceMatch.assessedAgeFromDocument != nil ? "\(faceMatch.assessedAgeFromDocument!)" : nil)
            addRow("Suspicious Photo", value: boolString(faceMatch.isSuspiciousPhoto))
        }

        // Anti Spoofing Result
        if let antiSpoof = data.diveResponse?.antiSpoofingVerificationResult {
            addSectionHeader("Anti-Spoofing Verification")
            addRow("Face Image Confidence", value: antiSpoof.antiSpoofingFaceImageConfidence != nil ? "\(antiSpoof.antiSpoofingFaceImageConfidence!)%" : nil)
            addRow("Data Fields Tampered", value: boolString(antiSpoof.isDataFieldsTampered))
            addRow("Photo Tampered", value: boolString(antiSpoof.isPhotoFromDocumentTampered))
        }

        // Done Button
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = UIColor(resource: .buttonBG3AB54A)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        doneButton.layer.cornerRadius = 8
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.addTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)

        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        contentStack.addArrangedSubview(spacer)
        contentStack.addArrangedSubview(doneButton)
    }

    private func addSectionHeader(_ title: String) {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label

        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 8).isActive = true

        contentStack.addArrangedSubview(spacer)
        contentStack.addArrangedSubview(label)
    }

    private func addRow(_ title: String, value: String?) {
        guard let val = value, !val.isEmpty else { return }

        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 8

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = val
        valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(titleLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        contentStack.addArrangedSubview(container)
    }

    private func boolString(_ value: Bool?) -> String? {
        guard let v = value else { return nil }
        return v ? "Yes" : "No"
    }

    @objc private func onDoneButtonTapped() {
        // Complete verification and dismiss
        BinbagVerify.shared.completeVerification(with: verificationData)
        self.navigationController?.dismiss(animated: true)
    }

    @IBAction func onDone(_ sender: UIButton) {
        // Complete verification and dismiss
        BinbagVerify.shared.completeVerification(with: verificationData)
        self.navigationController?.dismiss(animated: true)
    }
}
