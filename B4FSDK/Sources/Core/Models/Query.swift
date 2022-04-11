//
//  Query.swift
//  smartag
//
//  Created by Rubén Alonso on 07/01/2021.
//

import Foundation
import ObjectMapper

public struct Query: Mappable {
    /// Number of items to skip for pagination
    public var skip: Int?
    /// Number of items to take for pagination
    public var take: Int?
    /// List of campaigns' ids to filter. Use [idDecrypt](CampaignFilterCampaignType)
    public var filterCampaignType: [String]?
    /// List of comapanies' ids to filter
    public var filterCompany: [String]?
    /// List of badges' ids to filter
    public var filterBadge: [String]?

    /// Create query object
    /// - Parameters:
    ///   - take: Number of items to take for pagination
    ///   - skip: Number of items to skip for pagination
    public init(take: Int, skip: Int) {
        self.take = take
        self.skip = skip
    }

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        take <- map["take"]
        skip <- map["skip"]
        filterCampaignType <- map["filterCampaignType"]
        filterCompany <- map["filterCompany"]
        filterBadge <- map["filterBadge"]
    }
}
