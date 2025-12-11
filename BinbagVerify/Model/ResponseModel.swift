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

class CountryNameListResponse: Mappable {
    var id: String?
    var name: String?
    var code: Int?
    var logo: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        code <- map["code"]
        logo <- map["logo"]
    }
}

class DeveloperNameListResponse: Mappable {
    var id: String?
    var name: String?
    var countryCode: Int?
    var countryName: Int?
    var logo: String?
    var residenceData: [BuilderNameListResponse]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        logo <- map["logo"]
        residenceData <- map["residenceData"]
    }
}


class BuilderNameListResponse: Mappable {
    var id: String?
    var name: String?
    var countryCode: String?
    var logo: String?
    var countryName: String?
    var addresss: String?
    var latitude: String?
    var longitude: String?
    var developerId: String?
    var createdAt: String?
    var updatedAt: String?
    var type: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        logo <- map["logo"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        type <- map["type"]
        addresss <- map["addresss"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        developerId <- map["developerId"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        type <- map["type"]
    }
}

class CategoryNameListResponse : Mappable {
    var id: String?
    var name: String?
    var icon: String?
    var subCategory: [SubCategoryNameListResponse]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        icon <- map["icon"]
        subCategory <- map["subCategory"]
    }
}

class SubCategoryNameListResponse : Mappable {
    var id: String?
    var name: String?
    var icon: String?
    var subSubCategory: [SubSubCategoryNameListResponse]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        icon <- map["icon"]
        subSubCategory <- map["subSubCategory"]
    }
}

class SubSubCategoryNameListResponse : Mappable {
    var id: String?
    var name: String?
    var icon: String?
    var isSelected : Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        icon <- map["icon"]
        isSelected <- map["isSelected"]
    }
}

class DashboardListResponse : Mappable {
    var reminderData : [ReminderDateListResponse]?
    var eventData: [EventDataListResponse]?
    var advertisementData: [AdvertisementNameListResponse]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        reminderData <- map["reminderData"]
        eventData <- map["eventData"]
        advertisementData <- map["advertisementData"]
    }
}

class ReminderDateListResponse : Mappable {
    var date: Double?
    var isReminder: Bool?
    var data: [ReminderDataListResponse]?
    var isTodayDate: Bool? = false
    var isOpen : Bool? = false
    var isDisable: Bool? = false
    
    init(date: Double? = nil , isReminder: Bool? = nil , data: [ReminderDataListResponse]? = nil , isTodayDate: Bool? = false ,isOpen: Bool? = false,isDisable: Bool? = false) {
        self.date = date
        self.isReminder = isReminder
        self.data = data
        self.isTodayDate = isTodayDate
        self.isOpen = isOpen
        self.isDisable = isDisable ?? isDateInPast(date)
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        isReminder <- map["isReminder"]
        data <- map["data"]
        isTodayDate <- map["isTodayDate"]
        isOpen <- map["isOpen"]
        isDisable <- (map["isDisable"], TransformOf<Bool, Bool>(fromJSON: { $0 ?? self.isDateInPast(self.date) }, toJSON: { $0 }))
    }
    
    private func isDateInPast(_ timestamp: Double?) -> Bool {
           guard let timestamp = timestamp else { return false }
           return Date(timeIntervalSince1970: timestamp / 1000) < Date()
       }
}

class ReminderDataListResponse : Mappable {
    var _id: String?
    var type: Int?
    var dateAndTime: Double?
    var maintenanceId: String?
    var name: String?
    var icon: String?
    var serviceProviderName: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        type <- map["type"]
        dateAndTime <- map["dateAndTime"]
        maintenanceId <- map["maintenanceId"]
        name <- map["name"]
        icon <- map["icon"]
        serviceProviderName <- map["serviceProviderName"]
    }
}



//MARK: - Event
class EventDataListResponse : Mappable {
    var id: String?
    var name: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var details: String?
    var image: String?
    var dateAndTime: Double?
    var charge: Int?
    var isSelected : Bool?
    var isBooked: Bool?
    var bookedEventId: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        details <- map["details"]
        image <- map["image"]
        dateAndTime <- map["dateAndTime"]
        charge <- map["charge"]
        isSelected <- map["isSelected"]
        isBooked <- map["isBooked"]
        bookedEventId <- map["bookedEventId"]
    }
}

class EventBookingDetailResponse : Mappable {
    var id: String?
    var invoiceId: String?
    var payment: Int?
    var member: Int?
    var total : Int?
    var eventDetails: EventBookingDetailResponse?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        invoiceId <- map["invoiceId"]
        payment <- map["payment"]
        member <- map["member"]
        total <- map["total"]
        eventDetails <- map["eventDetails"]
    }
}

class AdvertisementNameListResponse : Mappable {
    var id: String?
    var name: String?
    var image: String?
    var isSelected : Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        image <- map["image"]
        isSelected <- map["isSelected"]
    }
}

//MARK: - Service provider
class ServiceProviderListResponse : Mappable {
    var id: String?
    var commercialName: String?
    var openTime: String?
    var closeTime: String?
    var details: String?
    var logo: String?
    var distance: Int?
    var isFreeDelivery: Bool?
    var discount: Int?
    var avgRating: Double?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var isFavourite: Bool?
    var openingDays : [Int]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        commercialName <- map["commercialName"]
        openTime <- map["openTime"]
        closeTime <- map["closeTime"]
        openingDays <- map["openingDays"]
        details <- map["details"]
        logo <- map["logo"]
        distance <- map["distance"]
        isFreeDelivery <- map["isFreeDelivery"]
        discount <- map["discount"]
        avgRating <- map["avgRating"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        longitude <- map["longitude"]
        isFavourite <- map["isFavourite"]
    }
}


//MARK: Reservation

//MARK: Restaurant
class RestaurantListResponse : Mappable {
    var id: String?
    var name: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var image: String?
    var moreInfo: String?
    var description: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        longitude <- map["longitude"]
        image <- map["image"]
        moreInfo <- map["moreInfo"]
        description <- map["description"]
    }
}

//MARK: Hall
class HallListResponse : Mappable {
    var id: String?
    var name: String?
    var seatingCapacity: String?
    var classroomStyle: Int?
    var theatreStyle: Int?
    var image: String?
    var buffet: Int?
    var platedMeal: Int?
    var uShape: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        seatingCapacity <- map["seatingCapacity"]
        classroomStyle <- map["classroomStyle"]
        theatreStyle <- map["theatreStyle"]
        image <- map["image"]
        buffet <- map["buffet"]
        platedMeal <- map["platedMeal"]
        uShape <- map["uShape"]
    }
}

//MARK: - Payment

//MARK: - Invoice
class InvoiceListResponse : Mappable {
    var id: String?
    var total: Int?
    var paymentStatus: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        total <- map["total"]
        paymentStatus <- map["paymentStatus"]
    }
}

class InvoiceDetailResponse : Mappable {
    var id: String?
    var invoiceNumber: Int?
    var items : [InvoiceItemListResponse]?
    var deliveryFee: Double?
    var tax: Double?
    var total: Double?
    var createdAt: Double?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        invoiceNumber <- map["invoiceNumber"]
        items <- map["items"]
        deliveryFee <- map["deliveryFee"]
        tax <- map["tax"]
        total <- map["total"]
        createdAt <- map["createdAt"]
    }
}

class InvoiceItemListResponse : Mappable {
    var name: String?
    var price: Double?
    var quantity: Int?
    var total: Double?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
        quantity <- map["quantity"]
        total <- map["total"]
    }
}


//MARK: - Security

//MARK: - Visitor
class VisitorListResponse: Mappable {

    var Id: String?
    var type: VisitorTypeListResponse?
    var fullName: String?
    var countryCode: String?
    var countryName: String?
    var phone: String?
    var idNumber: String?
    var idPhoto: String?
    var isAnyDay: Bool?
    var isAnyTime: Bool?
    var time: String?
    var date: [Int]?
    var reason: String?
    var residenceId: String?
    var userId: String?
    var createdAt: String?
    var updatedAt: String?
    
    var isRelativeOrFriend: Bool {
        return type?.name == Utility.getLocalizedString(value: "VISITOR_LIST_TYPE_RELATIVE") || type?.name == Utility.getLocalizedString(value: "VISITOR_LIST_TYPE_FRIEND")
       }

    required init?(map: Map){
    }

    func mapping(map: Map) {
        Id <- map["_id"]
        type <- map["type"]
        fullName <- map["fullName"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        phone <- map["phone"]
        idNumber <- map["idNumber"]
        idPhoto <- map["idPhoto"]
        isAnyDay <- map["isAnyDay"]
        isAnyTime <- map["isAnyTime"]
        time <- map["time"]
        date <- map["date"]
        reason <- map["reason"]
        residenceId <- map["residenceId"]
        userId <- map["userId"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
}

//MARK: - Visitor Type
class VisitorTypeListResponse: Mappable {

    var Id: String?
    var name: String?
    var createdAt: String?
    var updatedAt: String?
    
    init(Id:String? = nil,name:String? = nil,createdAt:String? = nil,updatedAt:String? = nil) {
        self.Id = Id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    required init?(map: Map){
    }

    func mapping(map: Map) {
        Id <- map["_id"]
        name <- map["name"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
}


//MARK: - Chat
class GroupListResponse : Mappable {
    var groupId: String?
    var roomId: String?
    var name: String?
    var icon: String?
    var unseenMessageCount: Int?
    var lastMessage: ChatLastMessageResponse?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        groupId <- map["groupId"]
        roomId <- map["roomId"]
        name <- map["name"]
        icon <- map["icon"]
        unseenMessageCount <- map["unseenMessageCount"]
        lastMessage <- map["lastMessage"]
    }
}

class ChatLastMessageResponse : Mappable {
    var message: String?
    var date: Double?
    var userName: String?
    var serProfile: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        date <- map["date"]
        userName <- map["userName"]
        serProfile <- map["serProfile"]
    }
}

class ChatListResponse: Mappable{
    var id: String?
    var senderId: String?
    var receiverId: String?
    var sender_id: String?
    var name: String?
    var sender_name: String?
    var image: String?
    var message : String?
    var created_at: String?
    var sender_image: String?
    var chat_user_id: String? = nil
    var timestamp: NSNumber?
   
    required init?(map: Map) {
        
    }
    
    init(id:String?,senderId:String?,receiverId:String?,sender_id: String?,name: String?,sender_name: String?,image: String?,message:String?,created_at:String?,chat_user_id:String? = nil,timestamp:NSNumber?){
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.sender_id = sender_id
        self.name = name
        self.sender_name = sender_name
        self.image = image
        self.message = message
        self.created_at = created_at
        self.chat_user_id = chat_user_id
        self.timestamp = timestamp
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        senderId <- map["senderId"]
        receiverId <- map["receiverId"]
        sender_id <- map["sender_id"]
        name <- map["name"]
        sender_name <- map["sender_name"]
        image <- map["image"]
        message <- map["message"]
        created_at <- map["createdAt"]
        sender_image <- map["sender_image"]
        chat_user_id <- map["chat_user_id"]
        timestamp <- map["timestamp"]
    }
}

class SectionMessageData: Mappable{
    var headerDate:String?
    var messageData:[ChatListResponse]?
    
    init(headerDate:String,messageData:[ChatListResponse]) {
        self.headerDate = headerDate
        self.messageData = messageData
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        headerDate <- map["headerDate"]
        messageData <- map["messageData"]
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
