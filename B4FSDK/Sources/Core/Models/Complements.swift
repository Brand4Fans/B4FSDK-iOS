//
//  Complements.swift
//  B4FSDK
//
//  Created by Rubén Alonso on 12/3/21.
//

import Foundation
import ObjectMapper

public struct ComplementList: Mappable {
    public var avatar: ComplementsURL?
    public var legal: [ComplementsURL]?
    public var favicon: ComplementsURL?
    ///:nodoc:
    public init?(map: Map) {

    }
    ///:nodoc:
    mutating public func mapping(map: Map) {
        avatar <- map["avatar"]
        legal <- map["legal"]
        favicon <- map["favicon"]
    }
}

public struct ComplementsURL: Mappable {
    /// Complement url.
    /// In case of image three params can be added at the end of the url with this format @width@height@quality to get an image thumbnail
    public var url: String?

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        url <- map["url"]
    }
}
