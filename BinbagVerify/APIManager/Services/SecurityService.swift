//
//  SecurityService.swift
//  SBM_App
//
//  Created by iRoid Dev on 02/04/24.
//

import Foundation

class SecurityService {
    static let shared = { SecurityService() }()
    
    //MARK: - Visitor List
    func visitorList(urlString :String, success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    //MARK: - Visitor Type List
    func visitorTypeList(success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: visitorTypeListURL) { statusCode, response in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }
    }
    
    
    func addVisitor(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: visitorCardURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func editVisitor(urlString :String,parameters: [String: Any] = [:], imageData : Data? = nil,videoData:Data? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithImage(method: .put, urlString: urlString, imageParameterName: "image", images: imageData, videoParameterName: "", videoData: videoData, audioParameterName: "", audioData: nil, bgThumbnailParameter: "", bgThumbImage: nil, videoPreviewParameter: "", videoPreview: nil, parameters: parameters)  { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func deleteVisitor(urlString :String,success : @escaping (Int, Response?)-> (),failure : @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .delete , urlString: urlString, success: {
            (statusCode , response) in
            success(statusCode, response)
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func accessCard(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: accessCardURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func lostAndFound(parameters: [String: Any] = [:], imageData : Data? = nil,videoData:Data? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithImage(method: .post, urlString: lostAndFoundURL, imageParameterName: "photo", images: imageData, videoParameterName: "", videoData: videoData, audioParameterName: "", audioData: nil, bgThumbnailParameter: "", bgThumbImage: nil, videoPreviewParameter: "", videoPreview: nil, parameters: parameters)  { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func reportCase(parameters: [String: Any] = [:], imageData : Data? = nil,videoData:Data? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithImage(method: .post, urlString: reportCaseURL, imageParameterName: "photo", images: imageData, videoParameterName: "", videoData: videoData, audioParameterName: "", audioData: nil, bgThumbnailParameter: "", bgThumbImage: nil, videoPreviewParameter: "", videoPreview: nil, parameters: parameters)  { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func uploadPhoto(imageData : Data? = nil,videoData:Data? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithImage(method: .post, urlString: uploadFileURL, imageParameterName: "file", images: imageData, videoParameterName: "", videoData: videoData, audioParameterName: "", audioData: nil, bgThumbnailParameter: "", bgThumbImage: nil, videoPreviewParameter: "", videoPreview: nil, parameters: [:])  { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
   
}
