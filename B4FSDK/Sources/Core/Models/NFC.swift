//
//  NFC.swift
//  smartag
//
//  Created by Rubén Alonso on 07/01/2021.
//

import Foundation

enum NFCType: String {
    case uri = "U"
    case text = "T"
    case smartPoster = "Sp"
    case xvCard = "text/x-vCard"
    case wifiConfig = "application/vnd.wfa.wsc"
}

struct NFCTags {
    public var text: String?
    public var type: NFCType?
}
