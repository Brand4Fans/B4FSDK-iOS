//
//  Alert.swift
//  B4FSDK
//
//  Created by Rubén Alonso on 15/3/21.
//

import ObjectMapper
public struct AlertList: Mappable {
    public var list = [AlertListItem]()

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        list <- map["list"]
    }
}

public struct AlertListItem: Mappable {
    /// Alert identifier
    public var id: String?
    /// Alert name
    public var name: String?
    /// Alert body
    public var body: String?
    /// Alert publish date
    public var publishDate: Date?
    /// Is the alert read
    public var read: Bool?
    /// Register identifier
    public var registerId: String?
    /// Register entity name. **New** or **Campaign**
    public var registerEntity: String?
    public var complements: ComplementList?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        body <- map["body"]
        publishDate <- (map["publishDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        read <- map["read"]
        registerId <- map["registerId"]
        registerEntity <- map["registerEntity"]
        complements <- map["complements"]
    }
}

public struct AlertCountNotRead: Mappable {
    /// Number of alerts not read by user
    public var totalNotRead: Int?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        totalNotRead <- map["totalNotRead"]
    }
}
