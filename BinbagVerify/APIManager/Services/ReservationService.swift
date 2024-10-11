//
//  ReservationService.swift
//  SBM_App
//
//  Created by iRoid Dev on 02/04/24.
//

import Foundation

class ReservationService {
    static let shared = { ReservationService() }()
    
    //MARK: - Select Event
    func restaurantListService(urlString: String, success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func hallListService(urlString: String, success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func sportReservation(urlString:String, parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: urlString, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
}
