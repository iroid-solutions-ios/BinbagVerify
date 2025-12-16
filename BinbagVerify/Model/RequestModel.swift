//
//  RequestModel.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation

struct LoginRequest: Encodable {
    var phone: String?
    var countryCode: Int?
    var password: String?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let phone = phone { params["phone"] = phone }
        if let countryCode = countryCode { params["countryCode"] = countryCode }
        if let password = password { params["password"] = password }
        return params
    }
}

struct SignUpRequest: Encodable {
    var firstName: String?
    var email: String?
    var lastName: String?
    var countryCode: String?
    var phoneNumber: String?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let firstName = firstName { params["firstName"] = firstName }
        if let email = email { params["email"] = email }
        if let lastName = lastName { params["lastName"] = lastName }
        if let countryCode = countryCode { params["countryCode"] = countryCode }
        if let phoneNumber = phoneNumber { params["phoneNumber"] = phoneNumber }
        return params
    }
}

struct LogoutRequest: Encodable {
    var deviceId: String?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let deviceId = deviceId { params["deviceId"] = deviceId }
        return params
    }
}

struct ChangePasswordRequest: Encodable {
    var oldPassword: String?
    var password: String?
    var passwordConfirmation: String?

    enum CodingKeys: String, CodingKey {
        case oldPassword
        case password = "newPassword"
        case passwordConfirmation = "confirmPassword"
    }

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let oldPassword = oldPassword { params["oldPassword"] = oldPassword }
        if let password = password { params["newPassword"] = password }
        if let passwordConfirmation = passwordConfirmation { params["confirmPassword"] = passwordConfirmation }
        return params
    }
}

struct ForgetPasswordRequest: Encodable {
    var countryCode: Int?
    var phone: Int?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let countryCode = countryCode { params["countryCode"] = countryCode }
        if let phone = phone { params["phone"] = phone }
        return params
    }
}

struct VerifyOTPRequest: Encodable {
    var otp: Int?
    var type: Int?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let otp = otp { params["otp"] = otp }
        if let type = type { params["type"] = type }
        return params
    }
}

struct ResetPasswordRequest: Encodable {
    var newPassword: String?
    var confirmPassword: String?

    enum CodingKeys: String, CodingKey {
        case newPassword = "password"
        case confirmPassword
    }

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let newPassword = newPassword { params["password"] = newPassword }
        if let confirmPassword = confirmPassword { params["confirmPassword"] = confirmPassword }
        return params
    }
}

struct UploadDocumentRequest: Encodable {
    var age: String?
    var documentType: String?
    var email: String?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let age = age { params["age"] = age }
        if let documentType = documentType { params["documentType"] = documentType }
        if let email = email { params["email"] = email }
        return params
    }
}
