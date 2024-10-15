//
//  RequestModel.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation
import ObjectMapper

class LoginRequest: Mappable {
    var phone: String?
    var countryCode:Int?
    var password: String?
    
    init(phone: String?,password: String?,countryCode:Int?) {
        self.phone = phone
        self.password = password
        self.countryCode = countryCode
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        phone <- map["phone"]
        password <- map["password"]
        countryCode <- map["countryCode"]
    }
}

class SignUpRequest: Mappable {
    var firstName: String?
    var email:String?
    var lastName:String?
    var countryCode: String?
    var phoneNumber:String?
    
    init(firstName: String?,lastName:String?,email: String?,countryCode: String?,phoneNumber: String?) {
        self.firstName = firstName
        self.email = email
        self.lastName = lastName
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        email <- map["email"]
        lastName <- map["lastName"]
        countryCode <- map["countryCode"]
        phoneNumber <- map["phoneNumber"]
    }
}

class LogoutRequest: Mappable{
    var deviceId:String?
    
    init(deviceId:String?) {
        self.deviceId = deviceId
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        deviceId <- map["deviceId"]
    }
}

class ChangePasswordRequest: Mappable {
    var oldPassword: String?
    var password: String?
    var passwordConfirmation: String?
    
    init(oldPassword:String?,password: String?,passwordConfirmation: String?) {
        self.oldPassword = oldPassword
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        oldPassword <- map["oldPassword"]
        password <- map["newPassword"]
        passwordConfirmation <- map["confirmPassword"]
    }
}

class ForgetPasswordRequest: Mappable {
    var countryCode: Int?
    var phone: Int?
    
    init(countryCode: Int?,phone: Int?) {
        self.countryCode = countryCode
        self.phone = phone
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        countryCode <- map["countryCode"]
        phone <- map["phone"]
    }
}

class VerifyOTPRequest: Mappable {
    var otp: Int?
    var type: Int?
    
    init(otp: Int?,type: Int?) {
        self.otp = otp
        self.type = type
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        otp <- map["otp"]
        type <- map["type"]
    }
}

class ResetPasswordRequest: Mappable {
    var newPassword: String?
    var confirmPassword: String?
    
    init(newPassword: String?,confirmPassword: String?) {
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        newPassword <- map["password"]
        confirmPassword <- map["confirmPassword"]
    }
}

//MARK: - Profile

class EditProfileRequest: Mappable {
    var fullName: String?
    var email:String?
    var dob:String?
    var countryCode: String?
    var countryName: String?
    var phone:String?
    var emergencyCountryCode: String?
    var emergencyCountryName: String?
    var emergencyPhone: String?
    var oldPassword:String?
    var newPassword: String?
    var confirmPassword: String?
    
    init(fullName: String?,email: String?,dob:String?,countryCode: String?,countryName:String?,phone: String?,emergencyCountryCode:String?,emergencyCountryName:String?,emergencyPhone: String?,oldPassword: String?,newPassword:String?,confirmPassword:String?) {
        self.fullName = fullName
        self.email = email
        self.dob = dob
        self.countryCode = countryCode
        self.countryName = countryName
        self.phone = phone
        self.emergencyCountryCode = emergencyCountryCode
        self.emergencyCountryName = emergencyCountryName
        self.emergencyPhone = emergencyPhone
        self.oldPassword = oldPassword
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        fullName <- map["fullName"]
        email <- map["email"]
        dob <- map["dob"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        phone <- map["phone"]
        emergencyCountryCode <- map["emergencyCountryCode"]
        emergencyCountryName <- map["emergencyCountryName"]
        emergencyPhone <- map["emergencyPhone"]
        oldPassword <- map["oldPassword"]
        newPassword <- map["newPassword"]
        confirmPassword <- map["confirmPassword"]
    }
}

class ContactUsRequest: Mappable {
    var fullName: String?
    var email: String?
    var description: String?
    
    init(fullName: String?,email: String?,description: String?) {
        self.fullName = fullName
        self.email = email
        self.description = description
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        fullName <- map["fullName"]
        email <- map["email"]
        description <- map["description"]
    }
}

class SuggestionRequest: Mappable {
    var type: String?
    var description: String?
    
    init(type: String?,description: String?) {
        self.type = type
        self.description = description
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        description <- map["description"]
    }
}

//MARK: - Event

class EventInvoiceGenerateMemberRequest: Mappable {
    var member: Int?
    
    init(member: Int?) {
        self.member = member
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        member <- map["member"]
    }
}

class EventBookRequest: Mappable {
    var type: Int?
    var member: Int?
    
    init(type: Int?,member: Int?) {
        self.type = type
        self.member = member
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        member <- map["member"]
    }
}

//MARK: - Maintenance

class MaintenanceRequest: Mappable {
    var priorityLevel: String?
    var suggestion: String?
    var dateAndTime: String?
    var time: String?
    var maintenanceServiceId: String?
    
    init(priorityLevel: String?,suggestion: String?,dateAndTime: String?,time: String?,maintenanceServiceId: String?) {
        self.priorityLevel = priorityLevel
        self.suggestion = suggestion
        self.dateAndTime = dateAndTime
        self.time = time
        self.maintenanceServiceId = maintenanceServiceId
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        priorityLevel <- map["priorityLevel"]
        suggestion <- map["case"]
        dateAndTime <- map["dateAndTime"]
        time <- map["time"]
        maintenanceServiceId <- map["maintenanceServiceId"]
    }
}

//MARK: - Reservation
class ReservationRequest: Mappable {
    var type: Int?
    var subCategoryId: String?
    var dateAndTime: Int?
    
    init(type: Int?,subCategoryId: String?, dateAndTime: Int?) {
        self.type = type
        self.subCategoryId = subCategoryId
        self.dateAndTime = dateAndTime
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        subCategoryId <- map["subCategoryId"]
        dateAndTime <- map["dateAndTime"]
    }
}

//MARK: - Security
class AddVisitorListRequest: Mappable {
    var visitors: [AddVisitorList]?
    var isAnyTime: Bool?
    var isAnyDay: Bool?
    var date: [Int]?
    var time: String?
    var idNumber: String?
    var reason: String?
    
    init(visitors: [AddVisitorList]?,isAnyTime: Bool?,isAnyDay: Bool?, date: [Int]?,time: String?,idNumber: String? = nil,reason: String?) {
        self.visitors = visitors
        self.isAnyTime = isAnyTime
        self.isAnyDay = isAnyDay
        self.date = date
        self.time = time
        self.idNumber = idNumber
        self.reason = reason
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        visitors <- map["visitors"]
        isAnyTime <- map["isAnyTime"]
        isAnyDay <- map["isAnyDay"]
        date <- map["date"]
        time <- map["time"]
        idNumber <- map["idNumber"]
        reason <- map["reason"]
    }
}

class AddVisitorList: Mappable {
    var type: String?
    var fullName: String?
    var countryCode: String?
    var countryName: String?
    var phone: String?
    
    init(type: String?,fullName: String?,countryCode: String?,countryName: String?,phone: String?) {
        self.type = type
        self.fullName = fullName
        self.countryCode = countryCode
        self.countryName = countryName
        self.phone = phone
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        fullName <- map["fullName"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        phone <- map["phone"]
    }
}

class editVisitorListRequest: Mappable {
    var countryCode: String?
    var countryName: String?
    var phone: String?
    var isAnyTime: String?
    var isAnyDay: String?
    var date: String?
    var time: String?
    
   init(countryCode: String?,countryName: String?,phone: String?,isAnyTime: String?,isAnyDay: String?,date: String?,time: String?) {
        self.countryCode = countryCode
        self.countryName = countryName
        self.phone = phone
        self.isAnyTime = isAnyTime
        self.isAnyDay = isAnyDay
        self.date = date
        self.time = time
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        phone <- map["phone"]
        isAnyTime <- map["isAnyTime"]
        isAnyDay <- map["isAnyDay"]
        date <- map["date"]
        time <- map["time"]
    }
}


class AccessCardRequest: Mappable {
    var type: Int?
    var data: NewAccessCardRequest?
    var visitorData: [NewAccessCardRequest]?
    
    init(type: Int?,data: NewAccessCardRequest?,visitorData: [NewAccessCardRequest]?) {
        self.type = type
        self.data = data
        self.visitorData = visitorData
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        data <- map["data"]
        visitorData <- map["data"]
    }
}

class NewAccessCardRequest: Mappable {
    var fullName: String?
    var countryCode: String?
    var countryName: String?
    var phone: String?
    var email: String?
    var idNumber: String?
    var idPhoto: String?
    
    init(fullName: String?,countryCode: String?,countryName: String?,phone: String?,email: String?,idNumber: String?,idPhoto: String?) {
        self.fullName = fullName
        self.countryCode = countryCode
        self.countryName = countryName
        self.phone = phone
        self.email = email
        self.idNumber = idNumber
        self.idPhoto = idPhoto
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        fullName <- map["fullName"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        phone <- map["phone"]
        email <- map["email"]
        idNumber <- map["idNumber"]
        idPhoto <- map["idPhoto"]
    }
}


class LostAndFoundRequest: Mappable {
    var type: String?
    var description: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    
    init(type: String?,description: String?,address: String?,latitude: String?,longitude: String?) {
        self.type = type
        self.description = description
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        description <- map["description"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}


class ReportCaseRequest: Mappable {
    var type: String?
    var description: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    
    init(type: String?,description: String?,address: String?,latitude: String?,longitude: String?) {
        self.type = type
        self.description = description
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        description <- map["description"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
