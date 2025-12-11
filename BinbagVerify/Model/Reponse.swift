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
    var documentVerificationData: DocumentVerificationData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        msg <- map["msg"]
        error <- map["error"]
        meta <- map["meta"]
        documentVerificationData <- map["data"]
    }
}
