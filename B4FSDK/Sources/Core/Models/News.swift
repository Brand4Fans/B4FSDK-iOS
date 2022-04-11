//
//  News.swift
//  smartag
//
//  Created by Rubén Alonso on 07/01/2021.
//

import Foundation
import ObjectMapper

public struct NewsList: Mappable {
    public var list = [NewsDetail]()

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        list <- map["list"]
    }
}


public struct NewsDetail: Mappable {
    /// News identifier
    public var id: String?
    /// News title
    public var title: String?
    /// News summary
    public var summary: String?
    /// News publish date
    public var publishDate: Date?
    /// News end date
    public var endDate: Date?
    /// News video url
    public var videoUrl: String?
    /// News html content
    public var html: String?
    public var complements: ComplementList?
    /// News list of sponsor
    public var sponsors: [SponsorListItem]?

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        summary <- map["summary"]
        publishDate <- (map["publishDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        endDate <- (map["endDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        videoUrl <- map["videoUrl"]
        html <- map["html"]
        complements <- map["complements"]
        sponsors <- map["sponsors"]
    }
}
