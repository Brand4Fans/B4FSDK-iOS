//
//  B4F.swift
//  smartag
//
//  Created by Rubén Alonso on 29/12/2020.
//

import Foundation


public protocol B4FDelegate {
    /// Tells the delegate a error ocurred with NFC
    /// - Parameter error: NFC error
    func nfcFailWith(error: Error)
    /// Tells the delegate a tag is detected.
    /// - Parameter tag: Value of the tag detected.
    func nfcDetectTags(tag: String)
    /// Tells the delegate that the NFC is active.
    func nfcDidBecomeActive()
}

public extension B4FDelegate {
    func nfcDidBecomeActive() {}
}

public class B4F {
    /// Returns the singleton B4F instance.
    public static var shared = B4F()
    /// The delegate of B4F object.
    public var delegate: B4FDelegate?
    /// API Key.
    /// Assign a value before using the rest of the methods
    public var apiKey: String?
    public var language: String?
    /// User's identifier
    /// Assign a value before using the rest of the methods
    public var userId: String? {
        didSet { updateVinculation() }
    }
    /// Device token for push notifications
    public var deviceToken: Data? {
        didSet { updateVinculation() }
    }

    /// Return campaigns methods
    public let campaigns = Campaigns()
    /// Return coupons methods
    public let coupons = Coupons()
    /// Return smarttags methods
    public let smarttags = Smarttags()
    /// Return alerts methods
    public let alerts = Alerts()
    /// Return user methods
    public let user = UserProfile()
    /// Return news methods
    public let news = News()

    private func updateVinculation() {
        guard let userId = userId else {
            return
        }
        let token = deviceToken?.map { String(format: "%02.2hhx", $0) }.joined()
        let request = VinculationRequest(idUser: userId, deviceToken: token)
        APIManager.shared.vinculation(parameters: request, nil)
    }

    /// Start NFC Reader
    /// - Parameter alertMessage: Message to show in NFC banner
    public func startNFC(alertMessage: String?) {
        NFCManager.shared.delegate = self
        NFCManager.shared.start(message: alertMessage)
    }

    /// Stop NFC Reader
    public func stopNFC() {
        NFCManager.shared.stop()
    }

    /// Campaings methods
    public struct Campaigns {
        fileprivate init() {}
        /// Get user campaings paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getMyCampaigns(query: Query?, _ completion: @escaping (Result<CampaignList, B4FError>) -> Void) {
            APIManager.shared.getUserCampaigns(query: query, completion)
        }

        /// Get campaigns available paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getAvailableCampaigns(query: Query?, _ completion: @escaping (Result<CampaignList, B4FError>) -> Void) {
            APIManager.shared.getAvailableCampaigns(query: query, completion)
        }

        /// Get campaign list filters
        /// - Parameter completion: A closure to be executed once the request has finished.
        public func getFiltersCampaign(_ completion: @escaping (Result<CampaignFilter, B4FError>) -> Void) {
            APIManager.shared.getCampaignFilters(completion)
        }

        /// Get the detail of a campaign from a user
        /// - Parameters:
        ///   - id: Campaign identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func getCampaignBy(id: String, _ completion: @escaping (Result<CampaignDetail, B4FError>) -> Void) {
            APIManager.shared.getCampaignBy(id: id, completion)
        }

        /// Subscribe to a campaign
        /// - Parameters:
        ///   - id: Identifier of the campaign to subscribe
        ///   - smartTagId: Smarttag identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func subscribeToCampaignWith(id: String, smartTagId: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.subscribeToCampaignWith(id: id, smartTagId: smartTagId, completion)
        }

        /// Link a smarttag and subscribe to a campaign
        /// - Parameters:
        ///   - id: Identifier of the campaign to subscribe
        ///   - smartTagCode: Smarttag code
        ///   - completion: A closure to be executed once the request has finished.
        public func linkAndSubscribeToCampaignWith(id: String, smartTagCode: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.linkAndSubscribeToCampaignWith(id: id, code: smartTagCode, completion)
        }
    }

    /// Coupons methods
    public struct Coupons {
        fileprivate init() {}
        /// Unsubscribe from a campaign
        /// - Parameters:
        ///   - couponId: Coupon identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func unsubscribeFromCampaignWith(couponId: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.unsubscribeFromCampaignWith(id: couponId, completion)
        }

        /// Get the coupons available to the user paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getCoupons(query: Query?, _ completion: @escaping (Result<CouponList, B4FError>) -> Void) {
            APIManager.shared.getCoupons(query: query, completion)
        }

        /// Get the coupons unavailable to the user paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getUnavailableCoupons(query: Query?, _ completion: @escaping (Result<CouponList, B4FError>) -> Void) {
            APIManager.shared.getCouponsUnavailable(query: query, completion)
        }

        /// get coupon list filters
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getFiltersCoupon(query: Query?, _ completion: @escaping (Result<CouponFilter, B4FError>) -> Void) {
            APIManager.shared.getFiltersCoupon(query: query, completion)
        }

        /// Get the detail of a coupon from a user
        /// - Parameters:
        ///   - id: Coupon identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func getCouponBy(id: String, _ completion: @escaping (Result<CouponListItem, B4FError>) -> Void) {
            APIManager.shared.getCouponBy(id: id, completion)
        }

        /// Mark a coupon as used
        /// - Parameters:
        ///   - id: Coupon identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func redeemCouponWith(id: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.redeemCouponWith(id: id, completion)
        }
    }

    /// News methods
    public struct News {
        fileprivate init() {}
        /// Get news paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getNews(query: Query?, _ completion: @escaping (Result<NewsList, B4FError>) -> Void) {
            APIManager.shared.getNews(query: query, completion)
        }

        /// Get new detail
        /// - Parameters:
        ///   - id: New's identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func getNewBy(id: String, _ completion: @escaping (Result<NewsDetail, B4FError>) -> Void) {
            APIManager.shared.getNewBy(id: id, completion)
        }
    }

    /// Smarttag methods
    public struct Smarttags {
        fileprivate init() {}
        /// Get the user smarttags paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getSmartTags(query: Query?, _ completion: @escaping (Result<SmartTagList, B4FError>) -> Void) {
            APIManager.shared.getSmartTags(query: query, completion)
        }

        /// Get the detail of a user smarttag
        /// - Parameters:
        ///   - id: Smarttag identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func getSmartTagBy(id: String, _ completion: @escaping (Result<SmartTagListItem, B4FError>) -> Void) {
            APIManager.shared.getSmartTagBy(id: id, completion)
        }

        /// Associate a smarttag with a user
        /// - Parameters:
        ///   - code: Smartag code
        ///   - completion: A closure to be executed once the request has finished.
        public func associateSmartTag(code: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.associateSmartTag(code: code, completion)
        }

        /// Disassociate a smarttag with a user
        /// - Parameters:
        ///   - code: Smartag code
        ///   - completion: A closure to be executed once the request has finished.
        public func disassociateSmartTag(code: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.disassociateSmartTag(code: code, completion)
        }
    }

    /// Alerts methods
    public struct Alerts {
        fileprivate init() {}
        /// Get the alerts for the user paginated
        /// - Parameters:
        ///   - query: Paginated query
        ///   - completion: A closure to be executed once the request has finished.
        public func getAlerts(query: Query?, _ completion: @escaping (Result<AlertList, B4FError>) -> Void) {
            APIManager.shared.getAlerts(query: query, completion)
        }

        /// Get number of alerts not read
        /// - Parameters:
        ///   - completion: A closure to be executed once the request has finished.
        public func getNotReadAlertsCount(_ completion: @escaping (Result<AlertCountNotRead, B4FError>) -> Void) {
            APIManager.shared.getNotReadAlertsCount(completion)
        }

        /// Mark a alert pending to read as read
        /// - Parameters:
        ///   - id: Alert's identifier
        ///   - completion: A closure to be executed once the request has finished.
        public func setAlertReadBy(id: String, _ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.readAlertBy(id: id, completion)
        }

        /// Mark alerts pending to read as read
        /// - Parameters:
        ///   - completion: A closure to be executed once the request has finished.
        public func setAllAlertsRead(_ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.readAllAlerts(completion)
        }
    }

    /// User methods
    public struct UserProfile {
        fileprivate init() {}
        /// Get the user's profile
        /// - Parameters:
        ///   - completion: A closure to be executed once the request has finished.
        public func getUser(_ completion: @escaping (Result<User, B4FError>) -> Void) {
            APIManager.shared.getUser(completion)
        }

        /// Updates the user's profile
        /// - Parameters:
        ///   - user: User data
        ///   - completion: A closure to be executed once the request has finished.
        public func updateUser(user: User, _ completion: @escaping (Result<User, B4FError>) -> Void) {
            APIManager.shared.updateUser(user: user, completion)
        }

        /// Delete a user
        /// - Parameters:
        ///   - completion: A closure to be executed once the request has finished.
        public func deleteUser(_ completion: @escaping (Result<Void, B4FError>) -> Void) {
            APIManager.shared.deleteUser(completion)
        }
    }
}

extension B4F: NFCManagerDelegate {
    func nfcManagerDidBecomeActive() {
        delegate?.nfcDidBecomeActive()
    }

    func nfcManager(didInvalidate error: Error) {
        delegate?.nfcFailWith(error: error)
    }

    func nfcManager(didDetect messages: [NFCTags]) {
        let tag = messages.first?.text
        delegate?.nfcDetectTags(tag: tag ?? "")
    }
}
