//
//  MaintenanceService.swift
//  SBM_App
//
//  Created by iRoid Dev on 03/04/24.
//

import Foundation

class MaintenanceService {
    static let shared = { MaintenanceService() }()
    
    func maintenance(urlString:String,parameters: [String: Any] = [:], imageData : Data? = nil,videoData:Data? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithImage(method: .post, urlString: urlString, imageParameterName: "photo", images: imageData, videoParameterName: "video", videoData: videoData, audioParameterName: "", audioData: nil, bgThumbnailParameter: "", bgThumbImage: nil, videoPreviewParameter: "", videoPreview: nil, parameters: parameters)  { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
}
