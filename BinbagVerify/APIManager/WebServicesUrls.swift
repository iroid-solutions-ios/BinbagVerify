//
//  WebServicesUrls.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation

//MARK: - API URLs

let serverUrl = "https://dev.iroidsolutions.com:4007/api/v1/"  // dev

//Auth
let loginURL = serverUrl + "auth/login"
let registerURL = serverUrl + "auth/register"
let verifyOTPURL = serverUrl + "auth/otp-verification"
let resendOTPURL = serverUrl + "auth/resend-otp"
let authResendOTPURL = serverUrl + "auth/verify-otp"
let editEmailURL = serverUrl + "auth/edit-email"
let resetPasswordURL = serverUrl + "password/reset"
let logoutURL = serverUrl + "auth/logout"
let forgotPasswordURL = serverUrl + "/password/forgot"
let termsAnPolicyURL = serverUrl + "user/terms-and-policy"
let changePasswordURL = serverUrl + "password/change"
let deleteAccountURL = serverUrl + "user/delete"
let editProfileURL = serverUrl + "/user"
let contactUsURL = serverUrl + "contact-us"
let suggestionComplaintURL = serverUrl + "suggestion-complaint"

//Developer
let countryListURL = serverUrl + "data/country"
let developerListURL = serverUrl + "data/developer/"
let residentListURL = serverUrl + "data/residence/"

//Home
let categoryListURL = serverUrl + "data/category"
let advertisementListURL = serverUrl + "/advertisement"
let clickAdvertisementURL = serverUrl + "advertisement/click/"
let dashboardListURL = serverUrl + "/dashboard"

//MARK: - Event detail
let eventDetailURL = serverUrl + "event/"
let eventDetailInvoiceURL = serverUrl + "event/invoice/"
let eventBookURL = serverUrl + "event/book/"

//Service
let laundryListURL = serverUrl + "service-provider/"

//MARK: - Reservation
let restaurantListURL = serverUrl + "reservation/restaurant"
let hallListURL = serverUrl + "reservation/hall"
let hallSportReservationURL = serverUrl + "reservation/"

//MARK: - Maintenance
let maintenanceURL = serverUrl + "maintenance"

//MARK: - Security
let visitorListURL = serverUrl + "security/visitor"
let visitorTypeListURL = serverUrl + "security/visitor-type"
let deleteVisitorURL = serverUrl + "security/visitor/"
let editVisitorURL = serverUrl + "security/visitor/"
let reportCaseURL = serverUrl + "security/report-case"
let lostAndFoundURL = serverUrl + "security/lost-found"
let uploadFileURL = serverUrl + "file"
let visitorCardURL = serverUrl + "security/visitor"
let accessCardURL = serverUrl + "security/access-card"

//MARK: - Payment
let invoiceListURL = serverUrl + "invoice"
let invoiceDetailURL = serverUrl + "invoice/"

//MARK: - Chat
let groupChatListURL = serverUrl + "chat/"




