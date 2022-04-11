//
//  SmartTag.swift
//  smartag
//
//  Created by Rubén Alonso on 29/12/2020.
//

import Foundation
import ObjectMapper

public struct SmartTagList: Mappable {
    public var list = [SmartTagListItem]()

    ///:nodoc:
    public init?(map: Map) { }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        list <- map["list"]
    }
}

public struct SmartTagListItem: Mappable {
    /// Smarttag identifier
    public var id: String?
    /// Smarttag nfc's code
    public var smarttagCode: String?
    /// Badge identifier
    public var badgeId: String?
    /// Badge reference
    public var badgeReference: String?
    /// Badge name
    public var badgeName: String?
    /// Badge description
    public var badgeDescription: String?
    /// Product identifier
    public var productId: String?
    /// Product reference
    public var productReference: String?
    /// Product name
    public var productName: String?
    /// Product description
    public var productDescription: String?
    public var productComplements: ComplementList?

    ///:nodoc:
    public init?(map: Map) { }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        id <- map["id"]
        smarttagCode <- map["smarttagCode"]
        badgeId <- map["badgeId"]
        badgeReference <- map["badgeReference"]
        badgeName <- map["badgeName"]
        badgeDescription <- map["badgeDescription"]
        productId <- map["productId"]
        productReference <- map["productReference"]
        productName <- map["productName"]
        productDescription <- map["productDescription"]
        productComplements <- map["productComplements"]
    }
}

struct LinkRequest: Mappable {
    var code: String?

    init(code: String) {
        self.code = code
    }
    
    ///:nodoc:
    init?(map: Map) {}

    ///:nodoc:
    mutating func mapping(map: Map) {
        code <- map["code"]
    }
}
