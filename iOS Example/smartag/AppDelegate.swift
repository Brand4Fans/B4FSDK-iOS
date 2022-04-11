//
//  AppDelegate.swift
//  smartag
//
//  Created by Rubén Alonso on 07/01/2021.
//

import UIKit
import B4FSDK

extension NSNotification.Name {
    static let smarttag = NSNotification.Name("smarttag")
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Theme.applyTheme()

        B4F.shared.apiKey = Constants.apiKey
        B4F.shared.userId = Constants.userId
        B4F.shared.language = "en"

        let bounds = UIScreen.main.bounds
        window = UIWindow(frame: bounds)

        let home = TabBarViewController()
        window?.rootViewController = home
        window?.makeKeyAndVisible()

        return true
    }
}

