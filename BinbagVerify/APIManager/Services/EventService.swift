//
//  EventService.swift
//  SBM_App
//
//  Created by iRoid Dev on 17/04/24.
//

import Foundation

class EventService {
    static let shared = { EventService() }()
    
    //MARK: - Select Event
    func eventDetail(urlString: String, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func eventInvoiceGenerator(urlString:String,parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: urlString, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
}
