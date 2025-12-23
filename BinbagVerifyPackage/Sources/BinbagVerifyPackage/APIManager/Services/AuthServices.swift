//
//  AuthServices.swift
//  Wenue
//
//  Created by iroid on 07/02/22.
//

import Foundation
import Alamofire

class AuthServices {
    static let shared = { AuthServices() }()
    
    //MARK: - Login User

    func uploadDocument(parameters: [String: Any] = [:], documentFrontImageData: Data? = nil,documentBackImageData: Data? = nil, faceImageData: Data? = nil ,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithMultipleDocumentImage(urlString: uploadDocumentURL, documentFrontImage: "documentFront", documentFrontImageData: documentFrontImageData, documentBackImage: "documentBack", documentBackImageData: documentBackImageData, faceImage: "livePhoto", faceImageData: faceImageData, parameters: parameters, success: { (statusCode, response) in
            success(statusCode,response)

        }, failure: { (error) in
            failure(error)

        })
    }

    // Reverify API - for face verification only
    func reverify(email: String, age: String, livePhotoData: Data?, success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        let parameters: [String: Any] = [
            "email": email,
            "age": age
        ]
        APIManager.shared.requestWithMultipleDocumentImage(urlString: reverifyURL, documentFrontImage: "", documentFrontImageData: nil, documentBackImage: "", documentBackImageData: nil, faceImage: "livePhoto", faceImageData: livePhotoData, parameters: parameters, success: { (statusCode, response) in
            success(statusCode, response)
        }, failure: { (error) in
            failure(error)
        })
    }

}
