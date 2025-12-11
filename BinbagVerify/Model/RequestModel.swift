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

class UploadDocumentRequest: Mappable {
    var age: String?
    var documentType: String?
    var email: String?
    
    init(age: String?,documentType: String?,email: String?) {
        self.age = age
        self.documentType = documentType
        self.email = email
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        age <- map["age"]
        documentType <- map["documentType"]
        email <- map["email"]
    }
}
