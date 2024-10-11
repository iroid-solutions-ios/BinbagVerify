//
//  CommanModel.swift
//  SBM_App
//
//  Created by iRoid Dev on 16/01/24.
//

import Foundation
import UIKit

struct OnBoardingModel {
    var image : String?
    var title : String?
    var backgroundImage: String?
    var description : String?
    
    init(image: String? = nil, title: String? = nil,backgroundImage: String? = nil, description: String? = nil) {
        self.image = image
        self.title = title
        self.backgroundImage = backgroundImage
        self.description = description
    }
}

struct EventBookingModel {
    var image : String?
    var title : String?
    var description : String?
    var isLink : Bool?
    
    init(image: String? = nil, title: String? = nil,description: String? = nil,isLink: Bool? = nil) {
        self.image = image
        self.title = title
        self.description = description
        self.isLink = isLink
    }
}

struct TimeModel {
    var title : String?
    var isSelected : Bool?
    var isDisable : Bool?
    
    init(title: String? = nil,isSelected: Bool? = false,isDisable: Bool? = false) {
        self.title = title
        self.isSelected = isSelected
        self.isDisable = isDisable
    }
}

struct DayListModel {
    
    var day : String?
    var date : String?
    var isTodayDate : Bool?
    var isSelected : Bool?
    var isDisable : Bool?
    var fullDate: String?
    
    init(day: String? = nil, date: String? = nil, isTodayDate: Bool? = false,isSelected : Bool? = false,isDisable: Bool? = false,fullDate: String? = nil) {
        self.day = day
        self.date = date
        self.isTodayDate = isTodayDate
        self.isSelected = isSelected
        self.isDisable = isDisable
        self.fullDate = fullDate
    }
}

struct PreferenceListModel {
    var title : String?
    var subTitle : String?
    var isSelected : Bool?
    
    init(title: String? = nil, subTitle: String? = nil,isSelected: Bool? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.isSelected = isSelected
    }
}

struct LanguageListModel {
    var language : String?
    var languageShortName : String?
    
    init(language: String? = nil, languageShortName: String? = nil) {
        self.language = language
        self.languageShortName = languageShortName
    }
}

struct EmojiListModel {
    var title : String?
    var image : String?
    var selectImage: String?
    var isSelected : Bool? = false
    
    init(title: String? = nil, image: String? = nil,selectImage: String? = nil,isSelected : Bool? = false) {
        self.title = title
        self.image = image
        self.selectImage = selectImage
        self.isSelected = isSelected
    }
}

struct VisitorListModel {
    var name : String?
    var contactNumber: String?
    var countryCode : String?
    var countryShortName : String?
    var visitorId : String?
    var visitorEmail : String?
    var image : UIImage?
    var imageData : Data?

    init(name: String? = nil, contactNumber: String? = nil, countryCode: String? = nil, countryShortName: String? = nil, visitorId: String? = nil, visitorEmail: String? = nil, image: UIImage? = nil, imageData: Data? = nil) {
        self.name = name
        self.contactNumber = contactNumber
        self.countryCode = countryCode
        self.countryShortName = countryShortName
        self.visitorId = visitorId
        self.visitorEmail = visitorEmail
        self.image = image
        self.imageData = imageData
    }
    
}

struct UploadMediaTypes {
    var fileName : String?
    var data : Data?
    var type : MediaType?
    
    init(fileName : String? = nil,data: Data? = nil,type : MediaType? = nil) {
        self.fileName = fileName
        self.data = data
        self.type = type
    }
}

enum CategoryType {
    case Setting
    case Maintenance
    case Lost_AND_FOUND
    case REPORT_A_CASE
    case ADD_VISITOR
}

enum ReservationType : Int {
    case Restaurant = 1
    case Hall = 3
    case Sports = 4
}

enum ConfirmationType {
    case MOBILE_VERIFY
    case CONFIRM
    case RESET_PASSWORD
    case RESERVE_CINEMA
    case RESERVE_HALL
    case RESERVE_SPORTS
    case INVITE_USER
    case UPLOAD_DOCUMENT
    case SUGGESTION_AND_COMPLAINT
    case PAYMENT_SUCCESSFUL
}

enum LocationDetailType {
    case EVENT
    case HALL
}

enum AlertType {
    case LOGOUT
    case DELETE_ACCOUNT
}

enum PayPaymentType : Int {
    case PAY_NOW = 1
    case PAY_LATER = 2
    case none
}

enum URLLinkStatus : Int{
    case PRIVACY_POLICY = 2
    case TERMS_AND_CONDITION = 1
    case COOKIE_POLICY = 3
    case AGREEMENT = 4
    case POLICIES = 5
    case INSURANCE = 6
    case WARRANTY = 7
    case FORMS = 8
    
    case DEFAULT = -1
   
}

enum MediaType : Int{
    case IMAGE = 1
    case VIDEO = 2
    case DOCUMENT = 3
    
    case DEFAULT = -1
   
}



//MARK: - MainCategory
enum MainCategoryType : String {
    
    case SERVICES = "Services"
    case MAINTENANCE = "Maintenance"
    case RESERVATION = "Reservation"
    case INVITATION = "Invitation"
    case PAYMENT = "Payment"
    case SECURITY = "Security"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "Services":
            self = .SERVICES
        case "Maintenance":
            self = .MAINTENANCE
        case "Reservation":
            self = .RESERVATION
        case "Invitation":
            self = .INVITATION
        case "Payment":
            self = .PAYMENT
        case "Security":
            self = .SECURITY
        default:
            return nil
        }
    }
}

//MARK: - Reservation
enum ReservationCategoryType : String {
    
    case RESTAURANT = "Restaurant"
    case CINEMA = "Cinema"
    case HALLS = "Halls"
    case SPORTS = "Sports"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "Restaurant":
            self = .RESTAURANT
        case "Cinema":
            self = .CINEMA
        case "Halls":
            self = .HALLS
        case "Sports":
            self = .SPORTS
        default:
            return nil
        }
    }
}

//enum SportsType: String {
//    
//    case TENNIS = "Tennis"
//    case SQUASH = "Squash"
//    case PADEL = "Padel"
//    case GOLF = "Golf"
//    case BOWLING = "Bowling"
//    case BASKETBALL = "Basketball"
//    case GAME_ROOM = "Game Room"
//    case PING_PONG = "Ping Pong"
//    case BILLIARD = "Billiard"
//    case DEFAULT = ""
//    
//    // Use default initializer with a fallback
//    static func from(rawValue: String) -> SportsType {
//        return SportsType(rawValue: rawValue) ?? .DEFAULT
//    }
//}


//MARK: - Payment
enum PaymentType : String {
    
    case INVOICE = "Invoice"
    case TRANSACTION = "Transaction"
    case OFFICE = "Office"
    case REWARDS = "Rewards"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "Invoice":
            self = .INVOICE
        case "Transaction":
            self = .TRANSACTION
        case "Office":
            self = .OFFICE
        case "Rewards":
            self = .REWARDS
        default:
            return nil
        }
    }
}

enum OfficeType : String {
    
    case AGREEMENTS = "Agreements"
    case POLICIES = "Policies"
    case INSURANCE = "Insurance"
    case WARRANTY = "Warranties"
    case DOWNLOAD = "Download"
    case UPLOAD = "Upload"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "Agreements":
            self = .AGREEMENTS
        case "Policies":
            self = .POLICIES
        case "Insurance":
            self = .INSURANCE
        case "Warranties":
            self = .WARRANTY
        case "Download":
            self = .DOWNLOAD
        case "Upload":
            self = .UPLOAD
        default:
            return nil
        }
    }
}

enum RewardType : String {
    
    case LOYALTY_POINTS = "Loyalty Points"
    case REDEEM_POINTS = "Redeem Points"
    case RESIDENT_OF_THE_MONTH = "Resident of The Month"
    case TERMS_AND_CONDITIONS = "Terms & Conditions"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "Loyalty Points":
            self = .LOYALTY_POINTS
        case "Redeem Points":
            self = .REDEEM_POINTS
        case "Resident of The Month":
            self = .RESIDENT_OF_THE_MONTH
        case "Terms & Conditions":
            self = .TERMS_AND_CONDITIONS
        default:
            return nil
        }
    }
}

//MARK: - Security

enum SecurityType : String {
    
    case VISITORS = "Visitors"
    case ACCESS_CARD = "Access Card"
    case LOST_AND_FOUND = "Lost & Found"
    case REPORT_A_CASE = "Report A Case"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "Visitors":
            self = .VISITORS
        case "Access Card":
            self = .ACCESS_CARD
        case "Lost & Found":
            self = .LOST_AND_FOUND
        case "Report A Case":
            self = .REPORT_A_CASE
        default:
            return nil
        }
    }
}


//MARK: - SubSubCategoryType
enum SubSubCategoryType : String {
    
    case OFFICE = "My Office"
    case REWARDS = "Rewards"
    case SPORTS = "Sports"
    
    case DEFAULT = ""
    
    init?(rawValue: String) {
        switch rawValue {
        case "My Office":
            self = .OFFICE
        case "Rewards":
            self = .REWARDS
        case "Sports":
            self = .SPORTS
        default:
            return nil
        }
    }
}

//MARK: - Comman Data
var durationArray = [Utility.getLocalizedString(value: "CINEMA_SELECT_DURATION_ONE_HOUR"),
                     Utility.getLocalizedString(value: "CINEMA_SELECT_DURATION_TWO_HOUR"),
                     Utility.getLocalizedString(value: "CINEMA_SELECT_DURATION_THREE_HOUR"),
                     Utility.getLocalizedString(value: "CINEMA_SELECT_DURATION_FOUR_HOUR"),
]
