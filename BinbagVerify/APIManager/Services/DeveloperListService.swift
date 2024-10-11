//
//  DeveloperListService.swift
//  SBM_App
//
//  Created by iRoid Dev on 24/01/24.
//

import Foundation

class DeveloperListService {
    static let shared = { DeveloperListService() }()
    
    //MARK: - Select Event
    func countryList(success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: countryListURL) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func developerList(urlString:String,success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func residentList(urlString:String, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
}
