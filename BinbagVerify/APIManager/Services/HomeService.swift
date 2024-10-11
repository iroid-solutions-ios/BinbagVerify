//
//  HomeService.swift
//  SBM_App
//
//  Created by iRoid Dev on 06/02/24.
//


import Foundation

class HomeService {
    static let shared = { HomeService() }()
    
    //MARK: - Select Event
    func homeServiceList(success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: categoryListURL) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func advertisementList(success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: advertisementListURL) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func clickAdvertisement(urlString:String,parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: urlString, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func dashboardList(success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: dashboardListURL) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }


}

