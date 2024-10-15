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
    func logIn(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: loginURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func register(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: registerURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }

    }
    
    func editProfile(urlString: String,parameters: [String: Any] = [:], imageData : Data? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithImage(method: .put, urlString: urlString, imageParameterName: "profileImage", images: imageData, videoParameterName: "", videoData: nil, audioParameterName: "", audioData: nil, bgThumbnailParameter: "", bgThumbImage: nil, videoPreviewParameter: "", videoPreview: nil, parameters: parameters)  { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func verifyOTP(parameters: [String: Any] = [:],accessToken:String? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: verifyOTPURL, parameters: parameters, accessToken: accessToken) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func resendOTP(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: resendOTPURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func resetPassword(parameters: [String: Any] = [:],accessToken:String? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: resetPasswordURL, parameters: parameters,accessToken: accessToken) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func authResendOTP(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: authResendOTPURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func editEmail(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: editEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func logout(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: logoutURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    
    func forgotPassword(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: forgotPasswordURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func changePassword(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: changePasswordURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func privacyPolicy(urlString: String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: urlString) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func deleteAccount(success : @escaping (Int, Response?)-> (),failure : @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .delete , urlString: deleteAccountURL, success: {
            (statusCode , response) in
            success(statusCode, response)
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func contactUs(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestAPIWithParameters(method: .post, urlString: contactUsURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func suggestionComplaint(urlString: String,parameters: [String: Any] = [:], documentArray : [UploadMediaTypes]? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.requestWithMultipleMedia(method: .post, urlString: urlString,documentParameterName: "attachments", documentListArray: documentArray ,parameters: parameters,success: {(statusCode, response) in
            success(statusCode,response)
        }, failure: { (error) in
            failure(error)
        })
    }
    
}
