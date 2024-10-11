//
//  Reponse.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation
import ObjectMapper

class Response: Mappable {
    
    var success: String?
    var message: String?
    var error: String?
    var msg: String?
    var meta: Meta?
    var loginResponse: LogInResponse?
    var countryNameListResponse: [CountryNameListResponse]?
    var developerNameListResponse: [DeveloperNameListResponse]?
    var categoryListResponse : [CategoryNameListResponse]?
    var subCategoryListResponse : [SubCategoryNameListResponse]?
    var selectSubCategoryResponse : SubCategoryNameListResponse?
    var subSubCategoryListResponse : [SubSubCategoryNameListResponse]?
    var advertisementNameListResponse : [AdvertisementNameListResponse]?
    var dashboardListResponse : DashboardListResponse?
    var serviceProviderListResponse : [ServiceProviderListResponse]?
    var serviceProviderResponse : ServiceProviderListResponse?
    var eventDataListResponse : EventDataListResponse?
    var eventBookingDetailResponse : EventBookingDetailResponse?
    var restaurantListResponse : [RestaurantListResponse]?
    var hallListResponse : [HallListResponse]?
    var invoiceListResponse : [InvoiceListResponse]?
    var invoiceDetailResponse : InvoiceDetailResponse?
    var visitorListResponse : [VisitorListResponse]?
    var visitorTypeListResponse : [VisitorTypeListResponse]?
    var visitorDetailResponse : VisitorListResponse?
    var fileUploadResponse : String?
    var chatListResponse : [ChatListResponse]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        msg <- map["msg"]
        error <- map["error"]
        meta <- map["meta"]
        loginResponse <- map["data"]
        countryNameListResponse <- map["data"]
        developerNameListResponse <- map["data"]
        categoryListResponse <- map["data"]
        subCategoryListResponse <- map["data"]
        selectSubCategoryResponse <- map["data"]
        subSubCategoryListResponse <- map["data"]
        advertisementNameListResponse <- map["data"]
        dashboardListResponse <- map["data"]
        serviceProviderListResponse <- map["data"]
        serviceProviderResponse <- map["data"]
        eventDataListResponse <- map["data"]
        eventBookingDetailResponse <- map["data"]
        restaurantListResponse <- map["data"]
        hallListResponse <- map["data"]
        fileUploadResponse <- map["data"]
        invoiceListResponse <- map["data"]
        invoiceDetailResponse <- map["data"]
        visitorListResponse <- map["data"]
        visitorTypeListResponse <- map["data"]
        visitorDetailResponse <- map["data"]
        chatListResponse <- map["data"]
    }
}
