//
//  ResponseModel.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation
import ObjectMapper

class LogInResponse: Mappable {
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
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        fullName <- map["fullName"]
        email <- map["email"]
        dob <- map["dob"]
        profileImage <- map["profileImage"]
        countryName <- map["countryName"]
        countryCode <- map["countryCode"]
        isPhoneVerified <- map["isPhoneVerified"]
        phone <- map["phone"]
        emergencyCountryCode <- map["emergencyCountryCode"]
        emergencyCountryName <- map["emergencyCountryName"]
        emergencyPhone <- map["emergencyPhone"]
        flatNo <- map["flatNo"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        emergencyPhone <- map["emergencyPhone"]
        auth <- map["auth"]
    }
}

class Auth: Mappable {
    
    var tokenType: String?
    var expiresIn: NSNumber?
    var accessToken: String?
    var refreshToken: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        tokenType <- map["tokenType"]
        expiresIn <- map["expiresIn"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
} 

class Meta: Mappable {
    var total: Int?
    var perPage: Int?
    var currentPage: Int?
    var lastPage: Int?
    var from: Int?
    var historyCount:Int?
    var notificationCount:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        total <- map["total"]
        perPage <- map["perPage"]
        currentPage <- map["currentPage"]
        lastPage <- map["lastPage"]
        from <- map["from"]
        historyCount <- map["historycount"]
        notificationCount <- map["notificationCount"]
    }
    
}

// MARK: - Data
class DocumentVerificationData: Mappable {
    var requestId: Int?
    var diveResponse: DiveResponse?

    required init?(map: Map) {}

    func mapping(map: Map) {
        requestId    <- map["requestId"]
        diveResponse <- map["diveResponse"]
    }
}


// MARK: - Dive Response
class DiveResponse: Mappable {
    var requestId: String?
    var document: Document?
    var documentConfidenceScores: DocumentConfidenceScores?
    var documentVerificationResult: DocumentVerificationResult?
    var faceMatchVerificationResult: FaceMatchVerificationResult?
    var antiSpoofingVerificationResult: AntiSpoofingVerificationResult?
    var externalVerificationResults: [ExternalVerificationResult]?
    var authenticationResults: [Any]?
    var requestData: Any?
    var images: Any?
    var reference: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        requestId                     <- map["requestId"]
        document                      <- map["document"]
        documentConfidenceScores      <- map["documentConfidenceScores"]
        documentVerificationResult    <- map["documentVerificationResult"]
        faceMatchVerificationResult   <- map["faceMatchVerificationResult"]
        antiSpoofingVerificationResult <- map["antiSpoofingVerificationResult"]
        externalVerificationResults   <- map["externalVerificationResults"]
        authenticationResults         <- map["authenticationResults"]
        requestData                   <- map["requestData"]
        images                        <- map["images"]
        reference                     <- map["reference"]
    }
}


// MARK: - Document Model
class Document: Mappable {
    var auditInformation: String?
    var cardRevisionDate: String?
    var endorsementsCode: String?
    var hazmatExpirationDate: String?
    var iin: String?
    var race: String?
    var restrictionCode: String?
    var personalNumber: String?
    var ssn: String?
    var suffix: String?
    var abbr3Country: String?
    var abbrCountry: String?
    var address: String?
    var city: String?
    var documentClass: String?
    var country: String?
    var dob: String?
    var expires: String?
    var eyes: String?
    var familyName: String?
    var firstName: String?
    var fullName: String?
    var gender: String?
    var hair: String?
    var height: String?
    var id: String?
    var idType: String?
    var issued: String?
    var issuedBy: String?
    var maidenName: String?
    var middleName: String?
    var placeOfBirth: String?
    var postalBox: String?
    var state: String?
    var weight: String?
    var zip: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        auditInformation     <- map["auditInformation"]
        cardRevisionDate     <- map["cardRevisionDate"]
        endorsementsCode     <- map["endorsementsCode"]
        hazmatExpirationDate <- map["hazmatExpirationDate"]
        iin                  <- map["iin"]
        race                 <- map["race"]
        restrictionCode      <- map["restrictionCode"]
        personalNumber       <- map["personalNumber"]
        ssn                  <- map["ssn"]
        suffix               <- map["suffix"]
        abbr3Country         <- map["abbr3Country"]
        abbrCountry          <- map["abbrCountry"]
        address              <- map["address"]
        city                 <- map["city"]
        documentClass        <- map["class"]
        country              <- map["country"]
        dob                  <- map["dob"]
        expires              <- map["expires"]
        eyes                 <- map["eyes"]
        familyName           <- map["familyName"]
        firstName            <- map["firstName"]
        fullName             <- map["fullName"]
        gender               <- map["gender"]
        hair                 <- map["hair"]
        height               <- map["height"]
        id                   <- map["id"]
        idType               <- map["idType"]
        issued               <- map["issued"]
        issuedBy             <- map["issuedBy"]
        maidenName           <- map["maidenName"]
        middleName           <- map["middleName"]
        placeOfBirth         <- map["placeOfBirth"]
        postalBox            <- map["postalBox"]
        state                <- map["state"]
        weight               <- map["weight"]
        zip                  <- map["zip"]
    }
}


// MARK: - Confidence Scores
class DocumentConfidenceScores: Mappable {
    var auditInformation: Int?
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

    required init?(map: Map) {}

    func mapping(map: Map) {
        auditInformation <- map["auditInformation"]
        cardRevisionDate <- map["cardRevisionDate"]
        endorsementsCode <- map["endorsementsCode"]
        hazmatExpirationDate <- map["hazmatExpirationDate"]
        iin <- map["iin"]
        race <- map["race"]
        restrictionCode <- map["restrictionCode"]
        personalNumber <- map["personalNumber"]
        ssn <- map["ssn"]
        suffix <- map["suffix"]
        abbr3Country <- map["abbr3Country"]
        abbrCountry <- map["abbrCountry"]
        address <- map["address"]
        city <- map["city"]
        documentClass <- map["class"]
        country <- map["country"]
        dob <- map["dob"]
        expires <- map["expires"]
        eyes <- map["eyes"]
        familyName <- map["familyName"]
        firstName <- map["firstName"]
        fullName <- map["fullName"]
        gender <- map["gender"]
        hair <- map["hair"]
        height <- map["height"]
        id <- map["id"]
        idType <- map["idType"]
        issued <- map["issued"]
        issuedBy <- map["issuedBy"]
        maidenName <- map["maidenName"]
        middleName <- map["middleName"]
        placeOfBirth <- map["placeOfBirth"]
        postalBox <- map["postalBox"]
        state <- map["state"]
        template <- map["template"]
        weight <- map["weight"]
        zip <- map["zip"]
    }
}


// MARK: - Verification Results
class DocumentVerificationResult: Mappable {
    var isDocumentExpired: Bool?
    var isOcrSuccess: Bool?
    var isPdf417Success: Bool?
    var isMrzSuccess: Bool?
    var isShuftiSuccess: Bool?
    var isDriversLicenseRealID: Bool?
    var isCommercialDriversLicense: Bool?
    var isDriveOnly: Bool?
    var isVeteran: Bool?
    var isDonor: Bool?
    var isLimitedDurationDocument: Bool?
    var isInvalidated: Bool?
    var isNonDomicile: Bool?
    var isEnhancedCredential: Bool?
    var isPermit: Bool?
    var documentConfidence: Int?

    required init?(map: Map) {}

    func mapping(map: Map) {
        isDocumentExpired <- map["isDocumentExpired"]
        isOcrSuccess <- map["isOcrSuccess"]
        isPdf417Success <- map["isPdf417Success"]
        isMrzSuccess <- map["isMrzSuccess"]
        isShuftiSuccess <- map["isShuftiSuccess"]
        isDriversLicenseRealID <- map["isDriversLicenseRealID"]
        isCommercialDriversLicense <- map["isCommercialDriversLicense"]
        isDriveOnly <- map["isDriveOnly"]
        isVeteran <- map["isVeteran"]
        isDonor <- map["isDonor"]
        isLimitedDurationDocument <- map["isLimitedDurationDocument"]
        isInvalidated <- map["isInvalidated"]
        isNonDomicile <- map["isNonDomicile"]
        isEnhancedCredential <- map["isEnhancedCredential"]
        isPermit <- map["isPermit"]
        documentConfidence <- map["documentConfidence"]
    }
}


// MARK: - Face Match
class FaceMatchVerificationResult: Mappable {
    var falseAcceptanceRate: Int?
    var faceMatchConfidence: Int?
    var isAgeCheckSuccess: Bool?
    var isGenderCheckSuccess: Bool?
    var assessedAgeFromSelfie: Int?
    var assessedAgeFromDocument: Int?
    var isSuspiciousPhoto: Bool?

    required init?(map: Map) {}

    func mapping(map: Map) {
        falseAcceptanceRate <- map["falseAcceptanceRate"]
        faceMatchConfidence <- map["faceMatchConfidence"]
        isAgeCheckSuccess <- map["isAgeCheckSuccess"]
        isGenderCheckSuccess <- map["isGenderCheckSuccess"]
        assessedAgeFromSelfie <- map["assessedAgeFromSelfie"]
        assessedAgeFromDocument <- map["assessedAgeFromDocument"]
        isSuspiciousPhoto <- map["isSuspiciousPhoto"]
    }
}


// MARK: - Anti Spoofing
class AntiSpoofingVerificationResult: Mappable {
    var antiSpoofingFaceImageConfidence: Int?
    var isDataFieldsTampered: Bool?
    var isPhotoFromDocumentTampered: Bool?

    required init?(map: Map) {}

    func mapping(map: Map) {
        antiSpoofingFaceImageConfidence <- map["antiSpoofingFaceImageConfidence"]
        isDataFieldsTampered <- map["isDataFieldsTampered"]
        isPhotoFromDocumentTampered <- map["isPhotoFromDocumentTampered"]
    }
}


// MARK: - External Verification Results
class ExternalVerificationResult: Mappable {
    var values: Any?
    var status: Int?
    var rawResponse: Any?
    var name: String?
    var displayName: String?
    var reason: String?
    var effect: Int?

    required init?(map: Map) {}

    func mapping(map: Map) {
        values      <- map["values"]
        status      <- map["status"]
        rawResponse <- map["rawResponse"]
        name        <- map["name"]
        displayName <- map["displayName"]
        reason      <- map["reason"]
        effect      <- map["effect"]
    }
}
