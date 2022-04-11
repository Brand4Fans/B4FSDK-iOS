//
//  Campaign.swift
//  smartag
//
//  Created by Rubén Alonso on 29/12/2020.
//

import Foundation
import ObjectMapper

public struct CampaignList: Mappable {
    public var list = [CampaignListItem]()

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        list <- map["list"]
    }
}


public class CampaignListItem: Mappable {
    /// Campaign identifier
    public var id: String?
    /// Campaign name
    public var name: String?
    /// Campaign short description
    public var shortDescription: String?
    /// Campaign long description
    public var longDescription: String?
    /// Campaign type identifier
    public var typeId: CampaignType?
    /// Campaign type name
    public var typeName: String?
    /// Campaign publish date
    public var publishDate: Date?
    /// Campaign start date
    public var startDate: Date?
    /// Campaign end date
    public var endDate: Date?
    /// Max number of use for coupon campaign
    public var couponMaxEntry: String?
    /// Max redeem date for coupon campaign
    public var couponMaxRedeemDate: Date?
    /// Must be confirmed by shop in coupon campaign
    public var couponConfShop: String?
    /// Campaign code for coupon campaign
    public var couponCampaignCode: String?
    /// Max number de contestant for raffle campaign
    public var raffleMaxContestant: String?
    /// Raffle date for raffle campaign
    public var raffleDate: String?
    /// Text shown for raffle winners
    public var raffleCongratsWin: String?
    /// Campaign list of sponsor
    public var sponsors: [SponsorListItem]?
    public var company: CompanyInfo?
    public var complements: ComplementList?

    ///:nodoc:
    required public init?(map: Map) {

    }

    ///:nodoc:
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        shortDescription <- map["shortDescription"]
        longDescription <- map["longDescription"]
        typeId <- (map["typeId"], EnumTransform<CampaignType>())
        typeName <- map["typeName"]
        publishDate <- (map["publishDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        startDate <- (map["startDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        endDate <- (map["endDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        couponMaxEntry <- map["couponMaxEntry"]
        couponMaxRedeemDate <- (map["couponMaxRedeemDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        couponConfShop <- map["couponConfShop"]
        couponCampaignCode <- map["couponCampaignCode"]
        raffleMaxContestant <- map["raffleMaxContestant"]
        raffleDate <- map["raffleDate"]
        raffleCongratsWin <- map["raffleCongratsWin"]
        sponsors <- map["sponsors"]
        company <- map["company"]
        complements <- map["complements"]
    }
}

public class CampaignDetail: CampaignListItem {
    /// List of campaign badges associated
    public var badgesList = [CampaignDetailBadge]()
    /// List of badges linked to user associated with the campaign
    public var userLinkedBadgesList = [CampaignDetailUserLinkedBadge]()
    /// List of badges linked to user not associated with the campaign
    public var userAvailableBadgesList = [CampaignDetailBadge]()

    ///:nodoc:
    public required init?(map: Map) {
        super.init(map: map)
    }

    ///:nodoc:
    public override func mapping(map: Map) {
        super.mapping(map: map)
        badgesList <- map["badgesList"]
        userLinkedBadgesList <- map["userLinkedBadgesList"]
        userAvailableBadgesList <- map["userAvailableBadgesList"]
    }
}

public struct CompanyInfo: Mappable {
    /// Company name
    public var name: String?
    /// Company color name
    public var colorName: String?
    /// Company color hexadecimal code
    public var colorHexaCode: String?
    public var complements: ComplementList?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    public mutating func mapping(map: Map) {
        name <- map["name"]
        colorName <- map["colorName"]
        colorHexaCode <- map["colorHexaCode"]
        complements <- map["complements"]
    }
}

public class CampaignDetailBadge: Mappable {
    /// Identifier of the relationship between the campaign and the badge
    public var campaignBadgeId: String?
    /// Badge identifier
    public var badgeId: String?
    /// Badge name
    public var badgeName: String?
    /// Badge description
    public var badgeDescription: String?
    /// Badge reference
    public var badgeReference: String?
    /// Number of smarttag associated with the badge
    public var badgeSmarttagCount: Int?
    /// Product identifier
    public var productId: String?
    /// Product name
    public var productName: String?
    /// Product description
    public var productDescription: String?
    /// Company identifier
    public var companyId: String?
    /// Badge type identifier
    public var badgeTypeId: String?
    public var complements: ComplementList?

    ///:nodoc:
    public required init?(map: Map) {

    }

    ///:nodoc:
    public func mapping(map: Map) {
        campaignBadgeId <- map["campaignBadgeId"]
        badgeId <- map["badgeId"]
        badgeName <- map["badgeName"]
        badgeDescription <- map["badgeDescription"]
        badgeReference <- map["badgeReference"]
        badgeSmarttagCount <- map["badgeSmarttagCount"]
        productId <- map["productId"]
        productName <- map["productName"]
        productDescription <- map["productDescription"]
        companyId <- map["companyId"]
        badgeTypeId <- map["badgeTypeId"]
        complements <- map["complements"]
    }
}

public class CampaignDetailUserLinkedBadge: CampaignDetailBadge {
    /// Coupon identifier
    public var couponId: String?
    /// Is coupon redeemed?
    public var redeemed: Bool?

    ///:nodoc:
    public required init?(map: Map) {
        super.init(map: map)
    }

    ///:nodoc:
    public override func mapping(map: Map) {
        super.mapping(map: map)
        couponId <- map["couponId"]
        redeemed <- map["redeemed"]
    }
}

public class CampaignDetailUserAvailableBadge: CampaignDetailBadge {
    /// Smarttag identifier
    public var smarttagId: String?

    ///:nodoc:
    public required init?(map: Map) {
        super.init(map: map)
    }

    ///:nodoc:
    public override func mapping(map: Map) {
        super.mapping(map: map)
        smarttagId <- map["smarttagId"]
    }
}

public enum CampaignType: Int {
    case unknown = 0
    case coupon
    case raffle
}

struct SubscribeRequest: Mappable {
    var smartTagUserId: String?

    init(id: String) {
        smartTagUserId = id
    }
    
    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        smartTagUserId <- map["smartTagUserId"]
    }
}


public class CampaignFilter: Mappable {
    /// List of type of campaigns
    public var listCampaignType = [CampaignFilterCampaignType]()
    /// List of companies
    public var listCompany = [CampaignFilterCompany]()
    /// List of badges
    public var listBadge = [CampaignFilterBadge]()

    ///:nodoc:
    required public init?(map: Map) {

    }

    ///:nodoc:
    public func mapping(map: Map) {
        listCampaignType <- map["listCampaignType"]
        listCompany <- map["listCompany"]
        listBadge <- map["listBadge"]
    }
}

public struct CampaignFilterCampaignType: Mappable {
    public var id: String?
    /// Id to use in filter
    public var idDecrypt: Int?
    public var name: String?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        id <- map["id"]
        idDecrypt <- map["idDecrypt"]
        name <- map["name"]
    }
}


public struct CampaignFilterCompany: Mappable {
    /// Campaign Id. Use in filter
    public var id: String?
    /// Campaign name
    public var name: String?
    public var complements: ComplementList?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        complements <- map["complements"]
    }
}

public struct CampaignFilterBadge: Mappable {
    /// Id to use in filter
    public var badgeId: String?
    /// Badge name
    public var badgeName: String?
    /// Badge description
    public var badgeDescription: String?
    /// Badge reference
    public var badgeReference: String?
    /// Product id
    public var productId: String?
    /// Product name
    public var productName: String?
    /// Product description
    public var productDescription: String?
    public var complements: ComplementList?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        badgeId <- map["badgeId"]
        badgeName <- map["badgeName"]
        badgeDescription <- map["badgeDescription"]
        badgeReference <- map["badgeReference"]
        productId <- map["productId"]
        productName <- map["productName"]
        productDescription <- map["productDescription"]
        complements <- map["complements"]
    }
}
