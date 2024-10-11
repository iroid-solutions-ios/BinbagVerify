//
//  ChatService.swift
//  SBM_App
//
//  Created by iRoid Dev on 19/04/24.
//

import Foundation

class ChatService {
    static let shared = { ChatService() }()
    
    //MARK: - group list
    func chatlist(urlString: String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
}
