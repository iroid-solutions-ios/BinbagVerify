//
//  ResponseModel.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation

struct LogInResponse: Codable {
    var id: String?
    var fullName: String?
    var email: String?
    var dob: Int?
    var profileImage: String?
    var countryName: String?
    var countryCode: String?
    var phone: String?
    var emergencyCountryCode: String?
    var emergencyCountryName: String?
    var emergencyPhone: String?
    var flatNo: String?
    var address: String?
    var latitude: Int?
    var longitude: Int?
    var isPhoneVerified: Bool?
    var auth: Auth?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName, email, dob, profileImage
        case countryName, countryCode, phone
        case emergencyCountryCode, emergencyCountryName, emergencyPhone
        case flatNo, address, latitude, longitude
        case isPhoneVerified, auth
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dob = try container.decodeIfPresent(Int.self, forKey: .dob)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.emergencyCountryCode = try container.decodeIfPresent(String.self, forKey: .emergencyCountryCode)
        self.emergencyCountryName = try container.decodeIfPresent(String.self, forKey: .emergencyCountryName)
        self.emergencyPhone = try container.decodeIfPresent(String.self, forKey: .emergencyPhone)
        self.flatNo = try container.decodeIfPresent(String.self, forKey: .flatNo)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.latitude = try container.decodeIfPresent(Int.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Int.self, forKey: .longitude)
        self.isPhoneVerified = try container.decodeIfPresent(Bool.self, forKey: .isPhoneVerified)
        self.auth = try container.decodeIfPresent(Auth.self, forKey: .auth)
    }

    // For creating from dictionary (backward compatibility)
    init?(JSON: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: JSON),
              let decoded = try? JSONDecoder().decode(LogInResponse.self, from: data) else {
            return nil
        }
        self = decoded
    }
}

struct Auth: Codable {
    var tokenType: String?
    var expiresIn: Int?
    var accessToken: String?
    var refreshToken: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
        self.expiresIn = try container.decodeIfPresent(Int.self, forKey: .expiresIn)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
    }
}

struct Meta: Codable {
    var total: Int?
    var perPage: Int?
    var currentPage: Int?
    var lastPage: Int?
    var from: Int?
    var historyCount: Int?
    var notificationCount: Int?

    enum CodingKeys: String, CodingKey {
        case total, perPage, currentPage, lastPage, from
        case historyCount = "historycount"
        case notificationCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
        self.perPage = try container.decodeIfPresent(Int.self, forKey: .perPage)
        self.currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage)
        self.lastPage = try container.decodeIfPresent(Int.self, forKey: .lastPage)
        self.from = try container.decodeIfPresent(Int.self, forKey: .from)
        self.historyCount = try container.decodeIfPresent(Int.self, forKey: .historyCount)
        self.notificationCount = try container.decodeIfPresent(Int.self, forKey: .notificationCount)
    }
}

// MARK: - DocumentVerificationData
public struct DocumentVerificationData: Codable {
    public var requestId: Int?
    public var diveResponse: DiveResponse?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestId = try container.decodeIfPresent(Int.self, forKey: .requestId)
        self.diveResponse = try container.decodeIfPresent(DiveResponse.self, forKey: .diveResponse)
    }
}

// MARK: - Dive Response
public struct DiveResponse: Codable {
    public var requestId: String?
    public var document: Document?
    public var documentConfidenceScores: DocumentConfidenceScores?
    public var documentVerificationResult: DocumentVerificationResult?
    public var faceMatchVerificationResult: FaceMatchVerificationResult?
    public var antiSpoofingVerificationResult: AntiSpoofingVerificationResult?
    public var externalVerificationResults: [ExternalVerificationResult]?
    public var reference: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
        self.document = try container.decodeIfPresent(Document.self, forKey: .document)
        self.documentConfidenceScores = try container.decodeIfPresent(DocumentConfidenceScores.self, forKey: .documentConfidenceScores)
        self.documentVerificationResult = try container.decodeIfPresent(DocumentVerificationResult.self, forKey: .documentVerificationResult)
        self.faceMatchVerificationResult = try container.decodeIfPresent(FaceMatchVerificationResult.self, forKey: .faceMatchVerificationResult)
        self.antiSpoofingVerificationResult = try container.decodeIfPresent(AntiSpoofingVerificationResult.self, forKey: .antiSpoofingVerificationResult)
        self.externalVerificationResults = try container.decodeIfPresent([ExternalVerificationResult].self, forKey: .externalVerificationResults)
        self.reference = try container.decodeIfPresent(String.self, forKey: .reference)
    }
}

// MARK: - Document Model
public struct Document: Codable {
    public var auditInformation: String?
    public var cardRevisionDate: String?
    public var endorsementsCode: String?
    public var hazmatExpirationDate: String?
    public var iin: String?
    public var race: String?
    public var restrictionCode: String?
    public var personalNumber: String?
    public var ssn: String?
    public var suffix: String?
    public var abbr3Country: String?
    public var abbrCountry: String?
    public var address: String?
    public var city: String?
    public var documentClass: String?
    public var country: String?
    public var dob: String?
    public var expires: String?
    public var eyes: String?
    public var familyName: String?
    public var firstName: String?
    public var fullName: String?
    public var gender: String?
    public var hair: String?
    public var height: String?
    public var id: String?
    public var idType: String?
    public var issued: String?
    public var issuedBy: String?
    public var maidenName: String?
    public var middleName: String?
    public var placeOfBirth: String?
    public var postalBox: String?
    public var state: String?
    public var weight: String?
    public var zip: String?

    enum CodingKeys: String, CodingKey {
        case auditInformation, cardRevisionDate, endorsementsCode
        case hazmatExpirationDate, iin, race, restrictionCode
        case personalNumber, ssn, suffix, abbr3Country, abbrCountry
        case address, city, country, dob, expires, eyes
        case familyName, firstName, fullName, gender, hair, height
        case id, idType, issued, issuedBy, maidenName, middleName
        case placeOfBirth, postalBox, state, weight, zip
        case documentClass = "class"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.auditInformation = try container.decodeIfPresent(String.self, forKey: .auditInformation)
        self.cardRevisionDate = try container.decodeIfPresent(String.self, forKey: .cardRevisionDate)
        self.endorsementsCode = try container.decodeIfPresent(String.self, forKey: .endorsementsCode)
        self.hazmatExpirationDate = try container.decodeIfPresent(String.self, forKey: .hazmatExpirationDate)
        self.iin = try container.decodeIfPresent(String.self, forKey: .iin)
        self.race = try container.decodeIfPresent(String.self, forKey: .race)
        self.restrictionCode = try container.decodeIfPresent(String.self, forKey: .restrictionCode)
        self.personalNumber = try container.decodeIfPresent(String.self, forKey: .personalNumber)
        self.ssn = try container.decodeIfPresent(String.self, forKey: .ssn)
        self.suffix = try container.decodeIfPresent(String.self, forKey: .suffix)
        self.abbr3Country = try container.decodeIfPresent(String.self, forKey: .abbr3Country)
        self.abbrCountry = try container.decodeIfPresent(String.self, forKey: .abbrCountry)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.documentClass = try container.decodeIfPresent(String.self, forKey: .documentClass)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.dob = try container.decodeIfPresent(String.self, forKey: .dob)
        self.expires = try container.decodeIfPresent(String.self, forKey: .expires)
        self.eyes = try container.decodeIfPresent(String.self, forKey: .eyes)
        self.familyName = try container.decodeIfPresent(String.self, forKey: .familyName)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.hair = try container.decodeIfPresent(String.self, forKey: .hair)
        self.height = try container.decodeIfPresent(String.self, forKey: .height)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.idType = try container.decodeIfPresent(String.self, forKey: .idType)
        self.issued = try container.decodeIfPresent(String.self, forKey: .issued)
        self.issuedBy = try container.decodeIfPresent(String.self, forKey: .issuedBy)
        self.maidenName = try container.decodeIfPresent(String.self, forKey: .maidenName)
        self.middleName = try container.decodeIfPresent(String.self, forKey: .middleName)
        self.placeOfBirth = try container.decodeIfPresent(String.self, forKey: .placeOfBirth)
        self.postalBox = try container.decodeIfPresent(String.self, forKey: .postalBox)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.weight = try container.decodeIfPresent(String.self, forKey: .weight)
        self.zip = try container.decodeIfPresent(String.self, forKey: .zip)
    }
}

// MARK: - Confidence Scores
public struct DocumentConfidenceScores: Codable {
    public var auditInformation: Int?
    var cardRevisionDate: Int?
    var endorsementsCode: Int?
    var hazmatExpirationDate: Int?
    var iin: Int?
    var race: Int?
    var restrictionCode: Int?
    var personalNumber: Int?
    var ssn: Int?
    var suffix: Int?
    var abbr3Country: Int?
    var abbrCountry: Int?
    var address: Int?
    var city: Int?
    var documentClass: Int?
    var country: Int?
    var dob: Int?
    var expires: Int?
    var eyes: Int?
    var familyName: Int?
    var firstName: Int?
    var fullName: Int?
    var gender: Int?
    var hair: Int?
    var height: Int?
    var id: Int?
    var idType: Int?
    var issued: Int?
    var issuedBy: Int?
    var maidenName: Int?
    var middleName: Int?
    var placeOfBirth: Int?
    var postalBox: Int?
    var state: Int?
    var template: Int?
    var weight: Int?
    var zip: Int?

    enum CodingKeys: String, CodingKey {
        case auditInformation, cardRevisionDate, endorsementsCode
        case hazmatExpirationDate, iin, race, restrictionCode
        case personalNumber, ssn, suffix, abbr3Country, abbrCountry
        case address, city, country, dob, expires, eyes
        case familyName, firstName, fullName, gender, hair, height
        case id, idType, issued, issuedBy, maidenName, middleName
        case placeOfBirth, postalBox, state, template, weight, zip
        case documentClass = "class"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.auditInformation = try container.decodeIfPresent(Int.self, forKey: .auditInformation)
        self.cardRevisionDate = try container.decodeIfPresent(Int.self, forKey: .cardRevisionDate)
        self.endorsementsCode = try container.decodeIfPresent(Int.self, forKey: .endorsementsCode)
        self.hazmatExpirationDate = try container.decodeIfPresent(Int.self, forKey: .hazmatExpirationDate)
        self.iin = try container.decodeIfPresent(Int.self, forKey: .iin)
        self.race = try container.decodeIfPresent(Int.self, forKey: .race)
        self.restrictionCode = try container.decodeIfPresent(Int.self, forKey: .restrictionCode)
        self.personalNumber = try container.decodeIfPresent(Int.self, forKey: .personalNumber)
        self.ssn = try container.decodeIfPresent(Int.self, forKey: .ssn)
        self.suffix = try container.decodeIfPresent(Int.self, forKey: .suffix)
        self.abbr3Country = try container.decodeIfPresent(Int.self, forKey: .abbr3Country)
        self.abbrCountry = try container.decodeIfPresent(Int.self, forKey: .abbrCountry)
        self.address = try container.decodeIfPresent(Int.self, forKey: .address)
        self.city = try container.decodeIfPresent(Int.self, forKey: .city)
        self.documentClass = try container.decodeIfPresent(Int.self, forKey: .documentClass)
        self.country = try container.decodeIfPresent(Int.self, forKey: .country)
        self.dob = try container.decodeIfPresent(Int.self, forKey: .dob)
        self.expires = try container.decodeIfPresent(Int.self, forKey: .expires)
        self.eyes = try container.decodeIfPresent(Int.self, forKey: .eyes)
        self.familyName = try container.decodeIfPresent(Int.self, forKey: .familyName)
        self.firstName = try container.decodeIfPresent(Int.self, forKey: .firstName)
        self.fullName = try container.decodeIfPresent(Int.self, forKey: .fullName)
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        self.hair = try container.decodeIfPresent(Int.self, forKey: .hair)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.idType = try container.decodeIfPresent(Int.self, forKey: .idType)
        self.issued = try container.decodeIfPresent(Int.self, forKey: .issued)
        self.issuedBy = try container.decodeIfPresent(Int.self, forKey: .issuedBy)
        self.maidenName = try container.decodeIfPresent(Int.self, forKey: .maidenName)
        self.middleName = try container.decodeIfPresent(Int.self, forKey: .middleName)
        self.placeOfBirth = try container.decodeIfPresent(Int.self, forKey: .placeOfBirth)
        self.postalBox = try container.decodeIfPresent(Int.self, forKey: .postalBox)
        self.state = try container.decodeIfPresent(Int.self, forKey: .state)
        self.template = try container.decodeIfPresent(Int.self, forKey: .template)
        self.weight = try container.decodeIfPresent(Int.self, forKey: .weight)
        self.zip = try container.decodeIfPresent(Int.self, forKey: .zip)
    }
}

// MARK: - Verification Results
public struct DocumentVerificationResult: Codable {
    public var isDocumentExpired: Bool?
    public var isOcrSuccess: Bool?
    public var isPdf417Success: Bool?
    public var isMrzSuccess: Bool?
    public var isShuftiSuccess: Bool?
    public var isDriversLicenseRealID: Bool?
    public var isCommercialDriversLicense: Bool?
    public var isDriveOnly: Bool?
    public var isVeteran: Bool?
    public var isDonor: Bool?
    public var isLimitedDurationDocument: Bool?
    public var isInvalidated: Bool?
    public var isNonDomicile: Bool?
    public var isEnhancedCredential: Bool?
    public var isPermit: Bool?
    public var documentConfidence: Int?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isDocumentExpired = try container.decodeIfPresent(Bool.self, forKey: .isDocumentExpired)
        self.isOcrSuccess = try container.decodeIfPresent(Bool.self, forKey: .isOcrSuccess)
        self.isPdf417Success = try container.decodeIfPresent(Bool.self, forKey: .isPdf417Success)
        self.isMrzSuccess = try container.decodeIfPresent(Bool.self, forKey: .isMrzSuccess)
        self.isShuftiSuccess = try container.decodeIfPresent(Bool.self, forKey: .isShuftiSuccess)
        self.isDriversLicenseRealID = try container.decodeIfPresent(Bool.self, forKey: .isDriversLicenseRealID)
        self.isCommercialDriversLicense = try container.decodeIfPresent(Bool.self, forKey: .isCommercialDriversLicense)
        self.isDriveOnly = try container.decodeIfPresent(Bool.self, forKey: .isDriveOnly)
        self.isVeteran = try container.decodeIfPresent(Bool.self, forKey: .isVeteran)
        self.isDonor = try container.decodeIfPresent(Bool.self, forKey: .isDonor)
        self.isLimitedDurationDocument = try container.decodeIfPresent(Bool.self, forKey: .isLimitedDurationDocument)
        self.isInvalidated = try container.decodeIfPresent(Bool.self, forKey: .isInvalidated)
        self.isNonDomicile = try container.decodeIfPresent(Bool.self, forKey: .isNonDomicile)
        self.isEnhancedCredential = try container.decodeIfPresent(Bool.self, forKey: .isEnhancedCredential)
        self.isPermit = try container.decodeIfPresent(Bool.self, forKey: .isPermit)
        self.documentConfidence = try container.decodeIfPresent(Int.self, forKey: .documentConfidence)
    }
}

// MARK: - Face Match
public struct FaceMatchVerificationResult: Codable {
    public var falseAcceptanceRate: Int?
    public var faceMatchConfidence: Int?
    public var isAgeCheckSuccess: Bool?
    public var isGenderCheckSuccess: Bool?
    public var assessedAgeFromSelfie: Int?
    public var assessedAgeFromDocument: Int?
    public var isSuspiciousPhoto: Bool?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.falseAcceptanceRate = try container.decodeIfPresent(Int.self, forKey: .falseAcceptanceRate)
        self.faceMatchConfidence = try container.decodeIfPresent(Int.self, forKey: .faceMatchConfidence)
        self.isAgeCheckSuccess = try container.decodeIfPresent(Bool.self, forKey: .isAgeCheckSuccess)
        self.isGenderCheckSuccess = try container.decodeIfPresent(Bool.self, forKey: .isGenderCheckSuccess)
        self.assessedAgeFromSelfie = try container.decodeIfPresent(Int.self, forKey: .assessedAgeFromSelfie)
        self.assessedAgeFromDocument = try container.decodeIfPresent(Int.self, forKey: .assessedAgeFromDocument)
        self.isSuspiciousPhoto = try container.decodeIfPresent(Bool.self, forKey: .isSuspiciousPhoto)
    }
}

// MARK: - Anti Spoofing
public struct AntiSpoofingVerificationResult: Codable {
    public var antiSpoofingFaceImageConfidence: Int?
    public var isDataFieldsTampered: Bool?
    public var isPhotoFromDocumentTampered: Bool?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.antiSpoofingFaceImageConfidence = try container.decodeIfPresent(Int.self, forKey: .antiSpoofingFaceImageConfidence)
        self.isDataFieldsTampered = try container.decodeIfPresent(Bool.self, forKey: .isDataFieldsTampered)
        self.isPhotoFromDocumentTampered = try container.decodeIfPresent(Bool.self, forKey: .isPhotoFromDocumentTampered)
    }
}

// MARK: - External Verification Results
public struct ExternalVerificationResult: Codable {
    public var status: Int?
    public var name: String?
    public var displayName: String?
    public var reason: String?
    public var effect: Int?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.effect = try container.decodeIfPresent(Int.self, forKey: .effect)
    }
}
