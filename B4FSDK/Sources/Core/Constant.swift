//
//  Constant.swift
//  smartag
//
//  Created by Rubén Alonso on 28/12/2020.
//

import Foundation

struct Constants {
    private init () {}
    static let formatDate = "yyyy-MM-dd'T'HH:mm:ss"
    struct API {
        static let base = "https://api.brand4fans.com"
        static let key = "X-API-KEY"
        struct Access {
            static let vinculation = "\(base)/access/vinculation"
        }
        struct Campaigns {
            static let replace = "{id}"
            static let list = "\(base)/campaign"
            static let user = "\(base)/campaign/my"
            static let available = "\(base)/campaign/available"
            static let get = "\(base)/campaign/\(replace)"
            static let filter = "\(base)/campaign/filter"
            static let subscribe = "\(base)/campaign/\(replace)/subscribe"
            static let linkAndSubscribe = "\(base)/campaign/\(replace)/linkAndSubscribe"
            static let redeem = "\(base)/campaign/\(replace)/redeem"
            static let unsubscribe = "\(base)/campaign/\(replace)/unsubscribe"
        }
        struct Coupons {
            static let replace = "{id}"
            static let available = "\(base)/coupon/to-use"
            static let unavailable = "\(base)/coupon/unavailable"
            static let filter = "\(base)/coupon/filter"
            static let get = "\(base)/coupon/\(replace)"
            static let redeem = "\(base)/coupon/\(replace)/redeem"
            static let unsubscribe = "\(base)/coupon/\(replace)/unsubscribe"
        }
        struct News {
            static let replace = "{id}"
            static let list = "\(base)/news"
            static let get = "\(base)/news/\(replace)"
        }
        struct SmartTag {
            static let replace = "{code}"
            static let list = "\(base)/smart-tag"
            static let get = "\(base)/smart-tag/\(replace)"
        }
        struct User {
            static let get = "\(base)/user-profile"
        }
        struct Alert {
            static let replace = "{id}"
            static let list = "\(base)/alert"
            static let notRead = "\(base)/alert/countNotRead"
            static let read = "\(base)/alert/\(replace)/read"
            static let readAll = "\(base)/alert/readAll"
        }
    }
}
