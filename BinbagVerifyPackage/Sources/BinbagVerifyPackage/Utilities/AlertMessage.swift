//
//  AlertMessage.swift
//  SBM_App
//
//  Created by iRoid Dev on 04/09/24.
//

import UIKit

struct CommonMessage{
    
    //Common
    static let Module_Under_Development = "This module is under development."
}

//MARK: Alert Message
struct AuthenticationAlertMessage{
    static let PHONE_NUMBER = "Please enter your phone number"
    static let MINIMUM_LETTER_PHONE = "Please enter phone number must be 6 character"
    static let MINIMUM_EMERGENCY_LETTER_PHONE = "Please enter emergency phone number must be 6 character"
    static let NOT_MATCH_PHONE = "Phone number and emergency phone number must not be same"
    static let PASSWORD = "Please enter password"
    static let MINIMUM_LETTER_PASSWORD = "Please enter password must be 8 character"
    static let PASSWORD_MUST_HAVE_AT_LEAST = "Password must have at least"
    
    static let FULL_NAME = "Please enter your full name"
    static let BIRTHDATE = "Select your birthdate"
    static let SIGNATURE = "please enter your signature"
    static let SIGNATURE_AND_FULL_NAME = "Signature and full name not must be same"
    static let EMAIL =  "Please enter your email"
    static let VALID_EMAIL = "Please enter your valid email"
    static let NOT_MATCH_PASSWORD = "New password and re-enter password must be same"
    static let PROFILE = "Please upload your personal photo"
    static let RE_ENTER_PASSWORD = "Please enter re-enter password"
    
    static let OTP = "Please enter 5 digit otp"
    static let FLAT_NO = "Please enter your flat number"
    static let ADDRESS = "Please enter your address"
    
    static let CURRENT_PASSWORD = "Please enter current password"
    static let NEW_PASSWORD = "Please enter new password"
    static let NEW_CONFIRM_PASSWORD = "Please enter new confirm password"
    
    static let SELECT_CHECKBOX = "Please select checkbox"
    
    static let USER_AGREEMENT = "Please select user agreement"
    static let PRIVACY_POLICY = "Please select privacy policy"
    static let MESSAGE = "Please enter the message"
    
    static let suggestion = "Please enter the description"
    
}

struct EventDetailAlertMessage{
    static let MEMBER_COUNT = "Please add member count"
}

//MARK: Maintenance
struct MaintenanceAlertMessage{
    static let SELECT_MAINTENANCE_SERVICE = "Please select any maintenance service"
    static let SELECT_MAINTENANCE_SERVICE_DATE = "Please select the date"
    static let SELECT_MAINTENANCE_SERVICE_TIME = "Please select the time"
    static let SELECT_MAINTENANCE_SERVICE_TERMS_AND_CONDITION = "Please select terms and condition"
}

//MARK: Reservation
struct ReservationAlertMessage{
    //MARK: - Cinema
    static let SELECT_RESERVATION_DURATION = "Please select cinema duration"
    static let SELECT_RESERVATION_DATE = "Please select reservation date"
    static let SELECT_RESERVATION_TIME = "Please select reservation time"
    
    //MARK: - Hall
    static let ENTER_EVENT_TYPE = "Please select event type"
    static let TOTAL_GUESTS = "Please add total guests"
}


//MARK: Security
struct SecurityAlertMessage{
    //MARK: - Visitor
    static let NO_VISITOR = "No visitor data is currently available."
    static let SELECT_TERMS_AND_CONDITION = "Please select the checkbox"
    static let SELECT_VISIT_DATES = "Please select visit dates"
    static let SELECT_VISIT_TIMES = "Please select visit time"
    static let ENTER_REASON_FOR_VISIT = "Please enter any reason for visit"
    
    //MARK: - Report a case
    static let REPORT_TYPE = "Please select report type"
    static let REPORT_A_CASE_DESCRIPTION = "Please enter the description"
    static let UPLOAD_IMAGE_OF_REPORT = "Please upload a photo"
    static let UPLOAD_VIDEO_OF_REPORT = "Please upload a video"
    static let REPORT_ADDRESS = "Please select your current location"
}
