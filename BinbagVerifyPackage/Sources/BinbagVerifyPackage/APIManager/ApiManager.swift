import UIKit
import Alamofire
import Network

// MARK: - Stripe Mode
enum StripeMode {
    case production
    case test
}

// MARK: - API Base Model Protocol
protocol APIBaseModel: Codable {
    var message: String? { get }
}

// MARK: - API Error
enum APIError: LocalizedError {
    case noInternetConnection
    case invalidResponse
    case unauthorized
    case serverError(String)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection available"
        case .invalidResponse:
            return "Something went wrong, please Try again later"
        case .unauthorized:
            return "Session expired. Please login again"
        case .serverError(let message):
            return message
        case .decodingError:
            return "Something went wrong, please Try again later"
        }
    }
}

// MARK: - API Manager
final class APIManager: @unchecked Sendable {
    static let shared = APIManager(baseURL: serverUrl)

    var baseURL: URL?
    var stripeMode: StripeMode = .production
    var platform = "iOS"

    // API Key from SDK configuration
    private var apiKey: String?

    // Debug logging flag - enabled in DEBUG builds
    #if DEBUG
    private let isAppInTestMode = true
    #else
    private let isAppInTestMode = false
    #endif

    private let session: Session
    private let networkMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    private let connectionQueue = DispatchQueue(label: "APIManager.connection", attributes: .concurrent)
    private var _isConnected = true

    var isConnected: Bool {
        connectionQueue.sync { _isConnected }
    }

    private func setConnectionStatus(_ status: Bool) {
        connectionQueue.async(flags: .barrier) { [weak self] in
            self?._isConnected = status
        }
    }

    required init(baseURL: String) {
        self.baseURL = URL(string: baseURL)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
        startNetworkMonitoring()
    }

    deinit {
        networkMonitor.cancel()
    }

    /// Update API configuration from SDK
    func updateConfig(apiKey: String, baseURL: String) {
        self.apiKey = apiKey
        self.baseURL = URL(string: baseURL)
    }

    private func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.setConnectionStatus(path.status == .satisfied)
        }
        networkMonitor.start(queue: monitorQueue)
    }
}

// MARK: - Generic Request Handler
extension APIManager {
    func request<B: APIBaseModel>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        responseType: B.Type
    ) async throws -> B {
        
        guard isConnected else { throw APIError.noInternetConnection }
        
        let headers = buildHeaders()
        logRequest(url: url, method: method, parameters: parameters)
        
        return try await withCheckedThrowingContinuation { continuation in
            let encoding: ParameterEncoding = (method == .get ? URLEncoding.default : JSONEncoding.default)
            
            session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<600)
                .responseData { [weak self] response in
                    guard let self else { return }
                    guard let statusCode = response.response?.statusCode else {
                        continuation.resume(throwing: APIError.invalidResponse)
                        return
                    }
                    
                    switch response.result {
                    case .success(let data):
                        self.logResponse(data: data, response: response)
                        do {
                            let decoded = try JSONDecoder().decode(B.self, from: data)
                            if statusCode == 401 {
                                Utility.removeUserData()
                                continuation.resume(throwing: APIError.serverError(decoded.message ?? ""))
                                return
                            }
                            if (500..<600).contains(statusCode) {
                                continuation.resume(throwing: APIError.serverError("Server error: \(decoded.message ?? "")"))
                                return
                            }
                            if (200..<300).contains(statusCode) {
                                continuation.resume(returning: decoded)
                            } else {
                                continuation.resume(throwing: APIError.serverError(decoded.message ?? ""))
                            }
                        } catch {
                            continuation.resume(throwing: APIError.decodingError)
                        }

                    case .failure(let error):
                        continuation.resume(throwing: self.mapError(error, statusCode: statusCode))
                    }
                }
        }
    }
}

// MARK: - Uploads (Async)
extension APIManager {
    private func uploadImage<T: APIBaseModel>(
        url: String,
        imageData: Data?,
        imageName: String = "image",
        fileName: String = "image.jpg",
        mimeType: String = "image/jpeg",
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard isConnected else { throw APIError.noInternetConnection }

        let headers = buildHeaders()
        logRequest(url: url, method: .post, parameters: parameters)

        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: { formData in
                    if let imageData = imageData {
                        formData.append(imageData, withName: imageName, fileName: fileName, mimeType: mimeType)
                    }
                    parameters?.forEach { key, value in
                        if let data = "\(value)".data(using: .utf8) {
                            formData.append(data, withName: key)
                        }
                    }
                },
                to: url,
                method: .post,
                headers: headers
            )
            .validate(statusCode: 200..<600)
            .responseData { [weak self] response in
                guard let self else { return }
                guard let statusCode = response.response?.statusCode else {
                    continuation.resume(throwing: APIError.invalidResponse)
                    return
                }

                switch response.result {
                case .success(let data):
                    self.logResponse(data: data, response: response)
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        if statusCode == 401 {
                            Utility.removeUserData()
                            continuation.resume(throwing: APIError.serverError(decoded.message ?? ""))
                            return
                        }
                        if (200..<300).contains(statusCode) {
                            continuation.resume(returning: decoded)
                        } else {
                            continuation.resume(throwing: APIError.serverError(decoded.message ?? ""))
                        }
                    } catch {
                        continuation.resume(throwing: APIError.decodingError)
                    }
                case .failure(let error):
                    continuation.resume(throwing: self.mapError(error, statusCode: response.response?.statusCode))
                }
            }
        }
    }
}

// MARK: - Convenience Wrappers
extension APIManager {
    private func get<B: APIBaseModel>(url: String, parameters: [String: Any]? = nil, responseType: B.Type) async throws -> B {
        try await request(url: url, method: .get, parameters: parameters, responseType: responseType)
    }
    
    private func post<B: APIBaseModel>(url: String, parameters: [String: Any]? = nil, responseType: B.Type) async throws -> B {
        try await request(url: url, method: .post, parameters: parameters, responseType: responseType)
    }
    
    private func put<B: APIBaseModel>(url: String, parameters: [String: Any]? = nil, responseType: B.Type) async throws -> B {
        try await request(url: url, method: .put, parameters: parameters, responseType: responseType)
    }
    
    private func delete<B: APIBaseModel>(url: String, parameters: [String: Any]? = nil, responseType: B.Type) async throws -> B {
        try await request(url: url, method: .delete, parameters: parameters, responseType: responseType)
    }
}

// MARK: - Type-Inferred Overloads
extension APIManager {
    func get<T: APIBaseModel>(_ url: String, parameters: [String: Any]? = nil) async throws -> T {
        try await get(url: url, parameters: parameters, responseType: T.self)
    }
    
    func post<T: APIBaseModel>(_ url: String, parameters: [String: Any]? = nil) async throws -> T {
        try await post(url: url, parameters: parameters, responseType: T.self)
    }
    
    func put<T: APIBaseModel>(_ url: String, parameters: [String: Any]? = nil) async throws -> T {
        try await put(url: url, parameters: parameters, responseType: T.self)
    }
    
    func delete<T: APIBaseModel>(_ url: String, parameters: [String: Any]? = nil) async throws -> T {
        try await delete(url: url, parameters: parameters, responseType: T.self)
    }
    
    
    func uploadImage<T: APIBaseModel>(
        _ url: String,
        imageData: Data?,
        imageName: String = "image",
        fileName: String = "image.jpg",
        mimeType: String = "image/jpeg",
        parameters: [String: Any]? = nil
    ) async throws -> T {
        try await uploadImage(url: url, imageData: imageData, imageName: imageName, fileName: fileName, mimeType: mimeType, parameters: parameters, responseType: T.self)
    }
    
//    func uploadMultipleImages<T: APIBaseModel>(
//        _ url: String,
//        images: [ImageUploadData],
//        method : Alamofire.HTTPMethod = .post,
//        parameters: [String: Any]? = nil
//    ) async throws -> T {
//        try await uploadMultipleImages(url: url, images: images,parameters: parameters, method: method, responseType: T.self)
//    }
}

// MARK: - Document Upload (Callback-based for backward compatibility)
extension APIManager {
    func requestWithMultipleDocumentImage(
        urlString: String,
        documentFrontImage: String,
        documentFrontImageData: Data?,
        documentBackImage: String,
        documentBackImageData: Data?,
        faceImage: String,
        faceImageData: Data?,
        parameters: [String: Any]? = nil,
        success: @escaping (Int, Response) -> (),
        failure: @escaping (String) -> ()
    ) {
        guard isConnected else {
            failure(APIError.noInternetConnection.localizedDescription)
            return
        }

        let headers = buildHeaders()
        logRequest(url: urlString, method: .post, parameters: parameters)

        session.upload(
            multipartFormData: { formData in
                // Add document front image
                if let frontData = documentFrontImageData, !documentFrontImage.isEmpty {
                    formData.append(frontData, withName: documentFrontImage, fileName: "\(documentFrontImage).jpg", mimeType: "image/jpeg")
                }

                // Add document back image
                if let backData = documentBackImageData, !documentBackImage.isEmpty {
                    formData.append(backData, withName: documentBackImage, fileName: "\(documentBackImage).jpg", mimeType: "image/jpeg")
                }

                // Add face/live photo image
                if let faceData = faceImageData, !faceImage.isEmpty {
                    formData.append(faceData, withName: faceImage, fileName: "\(faceImage).jpg", mimeType: "image/jpeg")
                }

                // Append other parameters
                parameters?.forEach { key, value in
                    if let data = "\(value)".data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                }
            },
            to: urlString,
            method: .post,
            headers: headers
        )
        .validate(statusCode: 200..<600)
        .responseData { [weak self] response in
            guard let self else { return }
            guard let statusCode = response.response?.statusCode else {
                failure(APIError.invalidResponse.localizedDescription)
                return
            }

            switch response.result {
            case .success(let data):
                self.logResponse(data: data, response: response)
                do {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    if statusCode == 401 {
                      //  self.handleUnautohrizartion()
                        failure(decoded.message ?? APIError.unauthorized.localizedDescription)
                        return
                    }
                    success(statusCode, decoded)
                } catch {
                    print("Decoding error: \(error)")
                    failure(APIError.decodingError.localizedDescription)
                }
            case .failure(let error):
                failure(self.mapError(error, statusCode: statusCode).localizedDescription)
            }
        }
    }
}

// MARK: - Helpers
extension APIManager {
    func buildHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]
        // Use API key from SDK configuration
        if let apiKey = apiKey, !apiKey.isEmpty {
            headers.add(name: "x-secret-key", value: apiKey)
        }
        if let accessToken = Utility.getAccessToken(), !accessToken.isEmpty {
            headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        }
        return headers
    }

    private func getCurrentUserSessionId() -> String? {
        return Utility.getAccessToken()
    }

    private func mapError(_ error: AFError, statusCode: Int? = nil) -> APIError {
        if case .sessionTaskFailed(let urlError as URLError) = error,
           urlError.code == .notConnectedToInternet {
            return .noInternetConnection
        }
        if let statusCode = statusCode {
            if statusCode == 401 {
                return .unauthorized
            }
            if (500..<600).contains(statusCode) {
                return .serverError("Server error (\(statusCode))")
            }
        }
        return .serverError(error.localizedDescription)
    }

    private func logRequest(url: String, method: HTTPMethod, parameters: [String: Any]?) {
        guard isAppInTestMode else { return }
        print("[API Request]")
        print("Method: \(method.rawValue.uppercased())")
        print("URL: \(url)")
        print("Headers: \(buildHeaders())")
        if let params = parameters,
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Parameters:\n\(jsonString)")
        } else {
            print("Parameters: nil")
        }
        print("----------------------------")
    }

    private func logResponse(data: Data?, response: AFDataResponse<Data>) {
        guard isAppInTestMode else { return }
        print("[API Response]")
        print("Status Code: \(response.response?.statusCode ?? -1)")
        if let data = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    print("Response JSON:\n\(prettyString)")
                }
            } catch {
                if let rawString = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(rawString)")
                }
            }
        } else {
            print("No response data.")
        }
        print("----------------------------")
    }
}

// MARK: - Callback-based API Methods (Legacy Support)
extension APIManager {

    /// POST/PUT/PATCH request with parameters using callbacks
    func requestAPIWithParameters(
        method: HTTPMethod,
        urlString: String,
        parameters: [String: Any],
        success: @escaping (Int, Response) -> (),
        failure: @escaping (String) -> ()
    ) {
        guard isConnected else {
            failure("No internet available.")
            return
        }

        let headers = buildHeaders()
        logRequest(url: urlString, method: method, parameters: parameters)

        session.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<600)
            .responseData { [weak self] response in
                guard let self else { return }

                switch response.result {
                case .success(let data):
                    self.logResponse(data: data, response: response)
                    guard let statusCode = response.response?.statusCode else {
                        failure("Invalid response")
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode(Response.self, from: data)
                        if (200..<300).contains(statusCode) {
                            success(statusCode, decoded)
                        } else if statusCode == 401 {
                            failure(decoded.message ?? "")
                        } else {
                            failure(decoded.message ?? "")
                        }
                    } catch {
                        failure("Decoding error")
                    }

                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
    }

    /// GET request with parameters using callbacks
    func requestAPIWithGetMethod(
        parameter: [String: Any] = [:],
        urlString: String,
        success: @escaping (Int, Response) -> (),
        failure: @escaping (String) -> ()
    ) {
        guard isConnected else {
            failure("No internet available.")
            return
        }

        let headers = buildHeaders()
        logRequest(url: urlString, method: .get, parameters: parameter)

        session.request(urlString, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<600)
            .responseData { [weak self] response in
                guard let self else { return }

                switch response.result {
                case .success(let data):
                    self.logResponse(data: data, response: response)
                    guard let statusCode = response.response?.statusCode else {
                        failure("Invalid response")
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode(Response.self, from: data)
                        if (200..<300).contains(statusCode) {
                            success(statusCode, decoded)
                        } else if statusCode == 401 {
                            Utility.removeUserData()
                        } else {
                            failure(decoded.message ?? "")
                        }
                    } catch {
                        failure("Decoding error")
                    }

                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
    }

    /// DELETE request using callbacks
    func requestAPIWithDeleteMethod(
        urlString: String,
        success: @escaping (Int, Response) -> (),
        failure: @escaping (String) -> ()
    ) {
        guard isConnected else {
            failure("No internet available.")
            return
        }

        let headers = buildHeaders()
        logRequest(url: urlString, method: .delete, parameters: nil)

        session.request(urlString, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<600)
            .responseData { [weak self] response in
                guard let self else { return }

                switch response.result {
                case .success(let data):
                    self.logResponse(data: data, response: response)
                    guard let statusCode = response.response?.statusCode else {
                        failure("Invalid response")
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode(Response.self, from: data)
                        if (200..<300).contains(statusCode) {
                            success(statusCode, decoded)
                        } else {
                            failure(decoded.message ?? "")
                        }
                    } catch {
                        failure("Decoding error")
                    }

                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
    }

    /// Multipart upload with single image, multiple images, and videos
    func requestWithImage(
        urlString: String,
        method: HTTPMethod = .post,
        imagePararmeterName: String,
        imageData: Data?,
        imagesParameterName: String,
        images: [Data]?,
        videoParameterName: String,
        videoData: [Data]?,
        parameters: [String: Any],
        success: @escaping (Int, Response) -> (),
        failure: @escaping (String) -> ()
    ) {
        guard isConnected else {
            failure("No internet available.")
            return
        }

        let headers = buildHeaders()
        logRequest(url: urlString, method: method, parameters: parameters)

        session.upload(
            multipartFormData: { multipartFormData in
                // Add single image
                if let imgData = imageData {
                    multipartFormData.append(imgData, withName: imagePararmeterName, fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpg")
                }

                // Add multiple images
                if let imagesArr = images {
                    for imgData in imagesArr {
                        multipartFormData.append(imgData, withName: imagesParameterName, fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpg")
                    }
                }

                // Add videos
                if let videoArr = videoData {
                    for vidData in videoArr {
                        multipartFormData.append(vidData, withName: videoParameterName, fileName: "\(UUID().uuidString).mp4", mimeType: "video/mp4")
                    }
                }

                // Add parameters
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: urlString,
            method: method,
            headers: headers
        )
        .uploadProgress { [weak self] progress in
            if self?.isAppInTestMode == true {
                print("Upload Progress: \(progress.fractionCompleted)")
            }
        }
        .validate(statusCode: 200..<600)
        .responseData { [weak self] response in
            guard let self else { return }

            switch response.result {
            case .success(let data):
                self.logResponse(data: data, response: response)
                guard let statusCode = response.response?.statusCode else {
                    failure("Invalid response")
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    if (200..<300).contains(statusCode) {
                        success(statusCode, decoded)
                    } else if statusCode == 401 {
                        failure(decoded.message ?? "")
                    } else {
                        failure(decoded.message ?? "")
                    }
                } catch {
                    failure("Decoding error")
                }

            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }

    /// Download file from URL
    func downloadFile(
        url: String,
        fileExtension: String,
        destinationPath: URL? = nil,
        success: @escaping (URL?) -> (),
        failure: @escaping (String) -> ()
    ) {
        let destination: DownloadRequest.Destination = { _, _ in
            var documentURL = destinationPath ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentURL.appendPathComponent(URL(string: url)?.lastPathComponent ?? "\(UUID().uuidString).\(fileExtension)")
            return (documentURL, [.removePreviousFile])
        }

        session.download(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination)
            .downloadProgress { [weak self] progress in
                if self?.isAppInTestMode == true {
                    print("Download Progress: \(progress.fractionCompleted)")
                }
            }
            .response { response in
                if let error = response.error {
                    failure(error.localizedDescription)
                } else {
                    success(response.fileURL)
                }
            }
    }
}

