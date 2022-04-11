//
//  Coupons.swift
//  B4FSDK
//
//  Created by Rubén Alonso on 25/2/21.
//

import ObjectMapper

public struct CouponList: Mappable {
    public var list = [CouponListItem]()

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating public func mapping(map: Map) {
        list <- map["list"]
    }
}

public class CouponListItem: Mappable {
    /// Coupon identifier
    public var id: String?
    /// Coupon state
    public var state: CouponState?
    /// Campaign identifier
    public var campaignId: String?
    /// Campaign name
    public var campaignName: String?
    /// Campaign short description
    public var campaignShortDescription: String?
    /// Campaign long description
    public var campaignLongDescription: String?
    /// Campaign publish date
    public var campaignPublishDate: Date?
    /// Campaign start date
    public var campaignStartDate: Date?
    /// Campaign end date
    public var campaignEndDate: Date?
    /// Max number of use for coupon campaign
    public var campaignCouponMaxEntry: String?
    /// Max redeem date for coupon campaign
    public var campaignCouponMaxRedeemDate: Date?
    /// Must be confirmed by shop in coupon campaign
    public var campaignCouponConfShop: String?
    /// Campaign code for coupon campaign
    public var campaignCouponCampaignCode: String?
    /// Max number de contestant for raffle campaign
    public var campaignRaffleMaxContestant: String?
    /// Raffle date for raffle campaign
    public var campaignRaffleDate: Date?
    /// Text shown for raffle winners
    public var campaignRaffleCongratsWin: String?
    /// Campaign type identifier
    public var campaignTypeId: CampaignType?
    public var company: CompanyInfo?
    public var complements: ComplementList?

    ///:nodoc:
    required public init?(map: Map) {

    }

    ///:nodoc:
    public func mapping(map: Map) {
        id <- map["id"]
        state <- (map["state"], EnumTransform<CouponState>())
        campaignId <- map["campaignId"]
        campaignName <- map["campaignName"]
        campaignShortDescription <- map["campaignShortDescription"]
        campaignLongDescription <- map["campaignLongDescription"]
        campaignPublishDate <- (map["campaignPublishDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        campaignStartDate <- (map["campaignStartDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        campaignEndDate <- (map["campaignEndDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        campaignCouponMaxEntry <- map["campaignCouponMaxEntry"]
        campaignCouponMaxRedeemDate <- (map["campaignCouponMaxRedeemDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        campaignCouponConfShop <- map["campaignCouponConfShop"]
        campaignCouponCampaignCode <- map["campaignCouponCampaignCode"]
        campaignRaffleMaxContestant <- map["campaignRaffleMaxContestant"]
        campaignRaffleDate <- (map["campaignRaffleDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
        campaignRaffleCongratsWin <- map["campaignRaffleCongratsWin"]
        campaignTypeId <- (map["campaignTypeId"], EnumTransform<CampaignType>())
        company <- map["company"]
        complements <- map["complements"]
    }
}

public class CouponDetail: CouponListItem {
    public var redeemed: Bool?
    public var redeemDate: Date?
    public var smarttagCode: String?
    public var badgeId: String?
    public var badgeReference: String?
    public var badgeName: String?
    public var badgeDescription: String?
    public var productId: String?
    public var productReference: String?
    public var productName: String?
    public var productDescription: String?
    public var productComplements: ComplementList?
    public var campaignComplements: ComplementList?

    ///:nodoc:
    public required init?(map: Map) {
        super.init(map: map)
    }

    ///:nodoc:
    public override func mapping(map: Map) {
        super.mapping(map: map)

        redeemed <- map["redeemed"]
        redeemDate <- (map["redeemDate"], CustomDateFormatTransform(formatString: Constants.formatDate))
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
        campaignComplements <- map["campaignComplements"]
    }
}

public class CouponFilter: CampaignFilter {
    
}

public enum CouponState: Int {
    case unknown = 0
    case active
    case expired
    case redeemed
    case won
}
