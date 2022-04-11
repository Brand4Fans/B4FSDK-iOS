//
//  Vinculation.swift
//  smartag
//
//  Created by Rubén Alonso on 29/12/2020.
//

import Foundation
import ObjectMapper

struct VinculationRequest: Mappable {
    var originUserHash: String?
    var idDevice: String?
    var tokenPush: String?
    var deviceOS: String?

    init(idUser: String, deviceToken: String?) {
        let device = UIDevice.current
        idDevice = device.identifierForVendor?.uuidString
        deviceOS = "ios"
        originUserHash = idUser
        tokenPush = deviceToken
    }

    ///:nodoc:
    public init?(map: Map) {}

    ///:nodoc:
    mutating func mapping(map: Map) {
        originUserHash <- map["originUserHash"]
        idDevice <- map["idDevice"]
        tokenPush <- map["tokenPush"]
        deviceOS <- map["deviceOS"]
    }
}

struct Vinculation: Mappable {
    var accessToken: String?

    ///:nodoc:
    init?(map: Map) {

    }

    ///:nodoc:
    mutating func mapping(map: Map) {
        accessToken <- map["accessToken"]
    }
}
