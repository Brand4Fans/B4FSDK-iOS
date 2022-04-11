//
//  Theme.swift
//  iOS Example
//
//  Created by Rubén Alonso on 25/3/21.
//

import UIKit

class Theme {
    static func applyTheme() {
        UITabBar.appearance().barTintColor = .primary
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().tintColor = .primary
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.primary]
    }
    
    static func applyApperanceFor(tabbar: UITabBar) {
        tabbar.tintColor = .white
        tabbar.barTintColor = .primary
        tabbar.unselectedItemTintColor = .white.withAlphaComponent(0.72)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .primary
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset.zero
        
        tabbar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabbar.scrollEdgeAppearance = appearance
        }
    }
}
