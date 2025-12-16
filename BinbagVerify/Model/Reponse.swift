//
//  Reponse.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation

struct Response: APIBaseModel {
    var success: Bool?
    var message: String?
    var error: String?
    var msg: String?
    var meta: Meta?
    var documentVerificationData: DocumentVerificationData?

    enum CodingKeys: String, CodingKey {
        case success, message, msg, error, meta
        case documentVerificationData = "data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.msg = try container.decodeIfPresent(String.self, forKey: .msg)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        self.meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        self.documentVerificationData = try container.decodeIfPresent(DocumentVerificationData.self, forKey: .documentVerificationData)
    }
}
