//
//  TabBarViewController.swift
//  smartag
//
//  Created by Rubén Alonso on 21/1/21.
//

import UIKit
import B4FSDK

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = UINavigationController(rootViewController:HomeViewController())
        home.tabBarItem = UITabBarItem(title: "News", image: #imageLiteral(resourceName: "icon-tab-news-white.png"), selectedImage: #imageLiteral(resourceName: "icon-tab-news-white.png"))

        let campaigns = UINavigationController(rootViewController:CampaignViewController())
        campaigns.tabBarItem = UITabBarItem(title: "Campaigns", image: #imageLiteral(resourceName: "icon-tab-explorar-on.png"), selectedImage: #imageLiteral(resourceName: "icon-tab-explorar-on.png"))

        let smarttags = UINavigationController(rootViewController: SmartagViewController())
        smarttags.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icon-tab-nfc.png"), tag: 1)
        smarttags.tabBarItem.imageInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
        smarttags.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)

        let coupons = UINavigationController(rootViewController: CouponsViewController())
        coupons.tabBarItem = UITabBarItem(title: "Coupons", image: #imageLiteral(resourceName: "icon-tab-campa-as.png"), selectedImage: #imageLiteral(resourceName: "icon-tab-campa-as.png"))

        let alert = UINavigationController(rootViewController: AlertViewController())
        alert.tabBarItem = UITabBarItem(title: "Notifications", image: #imageLiteral(resourceName: "icon-tab-message.png"), selectedImage: #imageLiteral(resourceName: "icon-tab-message.png"))
        
        Theme.applyApperanceFor(tabbar: self.tabBar)
        
        setViewControllers([home, coupons, smarttags, campaigns, alert], animated: true)
        hideTitleItem(item: tabBar.items![selectedIndex])
        getNotifications(tabBarItem: alert.tabBarItem)
    }

    func getNotifications(tabBarItem: UITabBarItem) {
        B4F.shared.alerts.getNotReadAlertsCount { (result) in
            switch result {
            case .success(let value):
                guard let value = value.totalNotRead, value > 0 else {
                    tabBarItem.badgeValue = nil
                    return
                }
                tabBarItem.badgeValue = "\(value)"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        hideTitleItem(item: item)
    }

    func hideTitleItem(item: UITabBarItem) {
        if item.tag != 1 {
            for tabBarItem in tabBar.items! where tabBarItem != item && tabBarItem.tag != 1 {
                tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
            }
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            for tabBarItem in tabBar.items! where tabBarItem != item {
                tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
            }
        }
    }
}
