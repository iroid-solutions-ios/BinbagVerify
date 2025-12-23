//
//  IDScanModels.swift
//  BinbagVerify
//
//  Created by Assistant on 12/11/2025.
//

import Foundation

public enum IDDocumentType: CaseIterable {
    case driversLicenseOrIDCard
    case passport
    case passportCard
    case internationalID

    public var title: String {
        switch self {
            case .driversLicenseOrIDCard: return "Driver's License or ID Card"
            case .passport: return "Passport"
            case .passportCard: return "Passport Card"
            case .internationalID: return "International ID"
        }
    }
}

public struct IDScanStep {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}

extension IDDocumentType {
    var steps: [IDScanStep] {
        switch self {
            case .driversLicenseOrIDCard:
                return [
                    IDScanStep(title: "Document Front"),
                    IDScanStep(title: "Back of Document"),
                    IDScanStep(title: "Face")
                ]
            case .passport:
                return [
                    IDScanStep(title: "Passport Front"),
                    IDScanStep(title: "Face")
                ]
            case .passportCard:
                return [
                    IDScanStep(title: "Back of Passport Card"),
                    IDScanStep(title: "Passport Front"),
                    IDScanStep(title: "Face")
                ]
            case .internationalID:
                return [
                    IDScanStep(title: "Back of Identification (MRZ)"),
                    IDScanStep(title: "Face")
                ]
        }
    }
}


