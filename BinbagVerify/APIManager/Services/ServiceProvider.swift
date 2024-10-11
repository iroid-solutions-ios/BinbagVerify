//
//  ServiceProvider.swift
//  SBM_App
//
//  Created by iRoid Dev on 27/02/24.
//

import Foundation

class ServiceProvider {
    static let shared = { ServiceProvider() }()
    
    //MARK: - Select Event
    func laundryListService(urlString:String,success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }

}
