//
//  APIManager.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class APIManager {
    static let shared = {
        APIManager(baseURL: serverUrl)
    }()
    
    var baseURL: URL?
    
    required init(baseURL: String) {
        self.baseURL = URL(string: baseURL)
    }
    
    func getHeader() -> HTTPHeaders {
        
        var headerDic: HTTPHeaders = [:]
        
        if Utility.getUserData() == nil {
            headerDic = [ "Accept" : "application/json" ]
        }
        else {
            if let accessToken = Utility.getAccessToken() {
                headerDic = [
                                "Authorization" : "Bearer "+accessToken,
                                "Accept" : "application/json"
                            ]
            } else {
                headerDic = [ "Accept" : "application/json" ]
            }
        }
        return headerDic
    }
    
    func isConnectedToNetwork()->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func requestAPIWithParameters(method: HTTPMethod,urlString: String,parameters: [String:Any],accessToken:String? = nil,success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        
        if isAppInTestMode {
            print("url ----> ", urlString)
            print("parameters ----> ", parameters)
            print("headers ----> ", getHeader())
        }
        
        var headerDic: HTTPHeaders = [:]
        headerDic = [
            "Authorization" : "Bearer "+(accessToken ?? ""),
                        "Accept" : "application/json"
                    ]
        
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Utility.getUserData() == nil ? headerDic : getHeader()).responseObject { (response: DataResponse<Response>) in
            switch response.result{
            case .success(let value):
                guard let statusCode = response.response?.statusCode else {
                    failure(value.message ?? "")
                    return
                }
                
                if isAppInTestMode {
                    print("response ----> ", response.result.value?.toJSON() as Any)
                }
                
                if (200..<300).contains(statusCode) {
                    success(statusCode,value)
                }
                else if statusCode == 401 {
                    Utility.clearNotifications()
                    Utility.hideIndicator()
                    Utility.removeUserData()
                    Utility.setRootLoginRegisterViewController()
                    userDefaults.setGuestUserLoggedIn(value: false)
                    userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
                    userDefaults.clearUserDefaultsValues()
                    //failure(value.message ?? "")
                }
                /*
                else if statusCode == 402{
                    failure(value.error ?? "")
                }
                else if statusCode == 403{
                    success(statusCode,value)
                }
                */
                else{
                    failure(value.message ?? "")
                }
                break
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }
        }
    }
    
    func requestAPIWithGetMethod(method: HTTPMethod,urlString: String,success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        
        if isAppInTestMode {
            print("url ----> ", urlString)
            print("headers ----> ", getHeader())
        }
        
        Alamofire.request(urlString, method: method, parameters: nil, encoding: JSONEncoding.default, headers: getHeader()).responseObject { (response: DataResponse<Response>) in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else {
                    failure(value.message ?? "")
                    return
                }
                
                if isAppInTestMode {
                    print("response ----> ", response.result.value?.toJSON() as Any)
                }
                
                if (200..<300).contains(statusCode) {
                    success(statusCode,value)
                }
                else if statusCode == 401 {
                    Utility.clearNotifications()
                    Utility.hideIndicator()
                    Utility.removeUserData()
                    Utility.setRootLoginRegisterViewController()
                    userDefaults.setGuestUserLoggedIn(value: false)
                    userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
                    userDefaults.clearUserDefaultsValues()
                    //failure(value.message ?? "")
                }
                else if statusCode == 402 {
                    failure(value.message ?? "")
                }
                else if statusCode == 403 {
                    success(statusCode,value)
                }
                else {
                    failure(value.message ?? "")
                }
                break
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }
        }
    }
    
    func requestWithImage(method: HTTPMethod,urlString : String, imageParameterName : String,images : Data?, videoParameterName: String, videoData : Data?, audioParameterName : String, audioData : Data?, bgThumbnailParameter : String, bgThumbImage : Data?, videoPreviewParameter : String, videoPreview : Data?, parameters : [String:Any],success : @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        
        if isConnectedToNetwork() == false {
            failure("No internet available.")
            return
        }
        
        if isAppInTestMode {
            print("url ----> ", urlString)
            print("parameters ----> ", parameters)
            print("headers ----> ", getHeader())
        }
        
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            if let image = images{
                multipartFormData.append(image, withName: imageParameterName,fileName: getFileName()+".jpg", mimeType: "image/jpg")
            }
            if let video = videoData{
                //                do {
                //                    let data = try Data(contentsOf: video, options: .mappedIfSafe)
                //                    print(data)
                multipartFormData.append(video, withName: videoParameterName, fileName: getFileName()+".mp4", mimeType: "video/mp4")
                //                } catch  {
                //                }
                if let thumbImage = bgThumbImage{
                    multipartFormData.append(thumbImage, withName: bgThumbnailParameter,fileName: getFileName()+".jpg", mimeType: "image/jpg")
                }
                
                if let videoPreviewGIF = videoPreview {
                    multipartFormData.append(videoPreviewGIF, withName: videoPreviewParameter,fileName: getFileName()+".gif", mimeType: "image/gif")
                }
            }
            if let audio = audioData{
                //                do {
                //                    let data = try Data(contentsOf: audio)
                //                    print(data)
                multipartFormData.append(audio, withName: audioParameterName, fileName: getFileName()+".mp3", mimeType: "audio/m4a")
                //                } catch  {
                //                }
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            print("Multipart form data parameters", parameters)
            
        }, to:urlString,method: method, headers:getHeader()){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    //                    SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Uploading...")
                })
                
                upload.responseObject { (response: DataResponse<Response>) in
                    switch response.result{
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            failure(value.message ?? "")
                            return
                        }
                        
                        if isAppInTestMode {
                            print("response ----> ", response.result.value?.toJSON() as Any)
                        }
                        
                        if (200..<300).contains(statusCode) {
                            success(statusCode,value)
                        }
                        else if statusCode == 401 {
                            // failure(value.message ?? "")
                            Utility.clearNotifications()
                            Utility.hideIndicator()
                            Utility.removeUserData()
                            Utility.setRootLoginRegisterViewController()
                            userDefaults.setGuestUserLoggedIn(value: false)
                            userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
                            userDefaults.clearUserDefaultsValues()
                        }
                        else if statusCode == 402 {
                            failure(value.message ?? "")
                        }
                        else if statusCode == 403 {
                            success(statusCode,value)
                        }
                        else {
                            failure(value.message ?? "")
                        }
                        break
                    case .failure(let error):
                        failure(error.localizedDescription)
                        break
                    }
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestWithMultipleImageParameter(method: HTTPMethod,urlString : String, imageParameterName : String,images : [Data]?,verificationImageParameterName : String,verifyImageData : Data?,profileImage:String,profileImageData:Data?, videoParameterName: String, videoData : Data?, audioParameterName : String, audioData : Data?, bgThumbnailParameter : String, bgThumbImage : Data?, videoPreviewParameter : String, videoPreview : Data?, parameters : [String:Any],success : @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        
        if isConnectedToNetwork() == false {
            failure("No internet available.")
            return
        }
        
        if isAppInTestMode {
            print("url ----> ", urlString)
            print("parameters ----> ", parameters)
            print("headers ----> ", getHeader())
        }
        
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            if let image = images{
                for imagedata in image{
                    multipartFormData.append(imagedata, withName: imageParameterName,fileName: getFileName()+".jpg", mimeType: "image/jpg")
                }
            }
            
            if let verifyImageData = verifyImageData{
                multipartFormData.append(verifyImageData, withName: verificationImageParameterName,fileName: getFileName()+".jpg", mimeType: "image/jpg")
            }
            
            if let profileImageData = profileImageData{
                multipartFormData.append(profileImageData, withName: profileImage,fileName: getFileName()+".jpg", mimeType: "image/jpg")
            }
            
            if let video = videoData{
                //                do {
                //                    let data = try Data(contentsOf: video, options: .mappedIfSafe)
                //                    print(data)
                multipartFormData.append(video, withName: videoParameterName, fileName: getFileName()+".mp4", mimeType: "video/mp4")
                //                } catch  {
                //                }
                if let thumbImage = bgThumbImage{
                    multipartFormData.append(thumbImage, withName: bgThumbnailParameter,fileName: getFileName()+".jpg", mimeType: "image/jpg")
                }
                
                if let videoPreviewGIF = videoPreview {
                    multipartFormData.append(videoPreviewGIF, withName: videoPreviewParameter,fileName: getFileName()+".gif", mimeType: "image/gif")
                }
            }
            if let audio = audioData{
                //                do {
                //                    let data = try Data(contentsOf: audio)
                //                    print(data)
                multipartFormData.append(audio, withName: audioParameterName, fileName: getFileName()+".mp3", mimeType: "audio/m4a")
                //                } catch  {
                //                }
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            print("Multipart form data parameters", parameters)
            
        }, to:urlString,method: method,headers:getHeader()){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    //                    SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Uploading...")
                })
                
                upload.responseObject { (response: DataResponse<Response>) in
                    switch response.result{
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            failure(value.message ?? "")
                            return
                        }
                        
                        if isAppInTestMode {
                            print("response ----> ", response.result.value?.toJSON() as Any)
                        }
                        
                        if (200..<300).contains(statusCode) {
                            success(statusCode,value)
                        }
                        else if statusCode == 401 {
                            // failure(value.message ?? "")
                            Utility.clearNotifications()
                            Utility.hideIndicator()
                            Utility.removeUserData()
                            Utility.setRootLoginRegisterViewController()
                            userDefaults.setGuestUserLoggedIn(value: false)
                            userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
                            userDefaults.clearUserDefaultsValues()
                        }
                        else if statusCode == 402 {
                            failure(value.message ?? "")
                        }
                        else if statusCode == 403 {
                            success(statusCode,value)
                        }
                        else {
                            failure(value.message ?? "")
                        }
                        break
                    case .failure(let error):
                        failure(error.localizedDescription)
                        break
                    }
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestWithMultipleMedia(method: HTTPMethod,urlString : String, documentParameterName : String,documentListArray : [UploadMediaTypes]?, parameters : [String:Any],success : @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        
        if isConnectedToNetwork() == false {
            failure("No internet available.")
            return
        }
        
        if isAppInTestMode {
            print("url ----> ", urlString)
            print("parameters ----> ", parameters)
            print("headers ----> ", getHeader())
        }
        
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            documentListArray?.forEach { obj in
                guard let data = obj.data, let mediaType = obj.type else { return }

                let fileName: String
                let mimeType: String

                switch mediaType {
                case .IMAGE:
                    fileName = (obj.fileName ?? getFileName()) + ".jpg"
                    mimeType = "image/jpg"
                    
                case .VIDEO:
                    fileName = (obj.fileName ?? getFileName()) + ".mp4"
                    mimeType = "video/mp4"
                    
                case .DOCUMENT:
                    fileName = (obj.fileName ?? getFileName()) + ".pdf"
                    mimeType = "application/pdf"
                    
                default:
                    return
                }

                multipartFormData.append(data, withName: documentParameterName, fileName: fileName, mimeType: mimeType)
            }

            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            print("Multipart form data parameters", parameters)
            
        }, to:urlString,method: method,headers:getHeader()){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    //                    SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Uploading...")
                })
                
                upload.responseObject { (response: DataResponse<Response>) in
                    switch response.result{
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            failure(value.message ?? "")
                            return
                        }
                        
                        if isAppInTestMode {
                            print("response ----> ", response.result.value?.toJSON() as Any)
                        }
                        
                        if (200..<300).contains(statusCode) {
                            success(statusCode,value)
                        }
                        else if statusCode == 401 {
                            // failure(value.message ?? "")
                            Utility.clearNotifications()
                            Utility.hideIndicator()
                            Utility.removeUserData()
                            Utility.setRootLoginRegisterViewController()
                            userDefaults.setGuestUserLoggedIn(value: false)
                            userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
                            userDefaults.clearUserDefaultsValues()
                        }
                        else if statusCode == 402 {
                            failure(value.message ?? "")
                        }
                        else if statusCode == 403 {
                            success(statusCode,value)
                        }
                        else {
                            failure(value.message ?? "")
                        }
                        break
                    case .failure(let error):
                        failure(error.localizedDescription)
                        break
                    }
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestWithMultipleImage(urlString : String, imageParameterName : String,images : [Data]?, layoutParameterName : String, layoutImage : Data?, threeSixtyLayoutParameterName : String,ThreeSixtyLayout: Data?, videoParameterName: String, videoData : Data?, audioParameterName : String, audioData : Data?, bgThumbnailParameter : String, bgThumbImage : Data?, videoPreviewParameter : String, videoPreview : Data?, parameters : [String:Any],success : @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        
        if isConnectedToNetwork() == false {
            failure("No internet available.")
            return
        }
        
        if isAppInTestMode {
            print("url ----> ", urlString)
            print("parameters ----> ", parameters)
            print("headers ----> ", getHeader())
        }
        
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            if let image = images{
                for imagedata in image{
                    multipartFormData.append(imagedata, withName: imageParameterName,fileName: getFileName()+".jpg", mimeType: "image/jpg")
                }
            }
            
            if let layoutImage = layoutImage{
                multipartFormData.append(layoutImage, withName: layoutParameterName,fileName: getFileName()+".jpg", mimeType: "image/jpg")
            }
            
            if let threeSixtyLayoutImage = ThreeSixtyLayout{
                multipartFormData.append(threeSixtyLayoutImage, withName: threeSixtyLayoutParameterName,fileName: getFileName()+".jpg", mimeType: "image/jpg")
            }
            
            
            if let video = videoData{
                //                do {
                //                    let data = try Data(contentsOf: video, options: .mappedIfSafe)
                //                    print(data)
                multipartFormData.append(video, withName: videoParameterName, fileName: getFileName()+".mp4", mimeType: "video/mp4")
                //                } catch  {
                //                }
                if let thumbImage = bgThumbImage{
                    multipartFormData.append(thumbImage, withName: bgThumbnailParameter,fileName: getFileName()+".jpg", mimeType: "image/jpg")
                }
                
                if let videoPreviewGIF = videoPreview {
                    multipartFormData.append(videoPreviewGIF, withName: videoPreviewParameter,fileName: getFileName()+".gif", mimeType: "image/gif")
                }
            }
            if let audio = audioData{
                //                do {
                //                    let data = try Data(contentsOf: audio)
                //                    print(data)
                multipartFormData.append(audio, withName: audioParameterName, fileName: getFileName()+".mp3", mimeType: "audio/m4a")
                //                } catch  {
                //                }
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            print("Multipart form data parameters", parameters)
            
        }, to:urlString,headers:getHeader()){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    //                    SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Uploading...")
                })
                
                upload.responseObject { (response: DataResponse<Response>) in
                    switch response.result{
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            failure(value.message ?? "")
                            return
                        }
                        
                        if isAppInTestMode {
                            print("response ----> ", response.result.value?.toJSON() as Any)
                        }
                        
                        if (200..<300).contains(statusCode) {
                            success(statusCode,value)
                        }
                        else if statusCode == 401 {
                            // failure(value.message ?? "")
                            Utility.clearNotifications()
                            Utility.hideIndicator()
                            Utility.removeUserData()
                            Utility.setRootLoginRegisterViewController()
                            userDefaults.setGuestUserLoggedIn(value: false)
                            userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
                            userDefaults.clearUserDefaultsValues()
                        }
                        else if statusCode == 402 {
                            failure(value.message ?? "")
                        }
                        else if statusCode == 403 {
                            success(statusCode,value)
                        }
                        else {
                            failure(value.message ?? "")
                        }
                        break
                    case .failure(let error):
                        failure(error.localizedDescription)
                        break
                    }
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    
    
    
}

struct ImageVideoMedia {
    var type : Int?
    var data : Data?
}
