//
//  User.swift
//  B4FSDK
//
//  Created by Rubén Alonso on 16/3/21.
//

import ObjectMapper

public struct User: Mappable {
    /// User's name
    public var name: String?
    /// User's surname
    public var surname: String?
    /// User's email
    public var email: String?
    /// User's birthday
    public var birthday: Date?
    /// Name of the user's tutor
    public var tutorName: String?
    /// Surname of the user's tutor
    public var tutorSurname: String?
    /// Email of the user's tutor
    public var tutorEmail: String?

    ///:nodoc:
    public init?(map: Map) {

    }

    ///:nodoc:
    mutating public func mapping(map: Map) {
        name <- map["name"]
        surname <- map["surname"]
        email <- map["email"]
        birthday <- (map["birthday"], CustomDateFormatTransform(formatString: Constants.formatDate))
        tutorName <- map["tutorName"]
        tutorSurname <- map["tutorSurname"]
        tutorEmail <- map["tutorEmail"]
    }
}
