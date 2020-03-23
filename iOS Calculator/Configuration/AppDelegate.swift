//
//  AppDelegate.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 23/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
          // do only pure app launch stuff, not interface stuff, it is done in SceneDelegate
        } else {
          self.window = UIWindow()
          self.window!.rootViewController = DashboardViewController()
          self.window!.makeKeyAndVisible()
          self.window!.backgroundColor = .red
        }
        return true
    }
}

