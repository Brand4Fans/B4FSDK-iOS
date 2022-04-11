//
//  B4FError.swift
//  smartag
//
//  Created by Rubén Alonso on 11/01/2021.
//

import Foundation
import ObjectMapper
import Alamofire

public struct B4FError: Error, Mappable {
    /// Error code from server
    public var httpCode: Int?
    /// Controlled error from server
    public var b4fErrorData: B4FErrorData?
    /// Uncontrolled error
    public var uncaughtError: String?
    var error: AFError?

    ///:nodoc:
    public init?(map: Map) {

    }

    init(error: AFError, data: Data?, code: Int) {
        self.error = error
        guard let data = data,
              let error = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            httpCode = code
            return
        }
        b4fErrorData = B4FErrorData(JSON: error)
    }

    init(message: String) {
        uncaughtError = message
    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        httpCode <- map["httpCode"]
        b4fErrorData <- map["b4fErrorData"]
        uncaughtError <- map["uncaughtError"]
    }

    public var localizedDescription: String {
        if let message = b4fErrorData?.key {
            return message
        } else if let message = uncaughtError {
            return message
        } else {
            return error?.localizedDescription ?? "unknown"
        }
    }

    public var code: Int? {
        if let message = b4fErrorData?.code {
            return message
        } else if let code = httpCode {
            return code
        } else {
            return error?.responseCode
        }
    }
}

public struct B4FErrorData: Mappable {
    public var code: Int?
    public var message: String?
    public var key: String?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        code <- map["StatusCode"]
        key <- map["Key"]
        message <- map["Message"]
    }
}
