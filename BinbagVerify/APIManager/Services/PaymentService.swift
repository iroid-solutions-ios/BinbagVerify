//
//  PaymentService.swift
//  SBM_App
//
//  Created by iRoid Dev on 17/04/24.
//

import Foundation

class PaymentService {
    static let shared = { PaymentService() }()
    
    //MARK: - Invoice list
    func invoiceList(urlString: String, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    func invoiceDetail(urlString: String, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
}
