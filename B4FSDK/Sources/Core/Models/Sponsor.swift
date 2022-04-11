//
//  Sponsor.swift
//  B4FSDK
//
//  Created by Rubén Alonso on 18/3/21.
//

import ObjectMapper

public struct SponsorListItem: Mappable {
    /// Sponsor's id
    public var id: String?
    /// Sponsor's name
    public var name: String?
    /// Sponsor's color name
    public var colorName: String?
    /// Sponsor's color hexadecimal code
    public var colorHexaCode: String?
    public var complements: ComplementList?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        colorName <- map["colorName"]
        colorHexaCode <- map["colorHexaCode"]
        complements <- map["complements"]
    }
}
