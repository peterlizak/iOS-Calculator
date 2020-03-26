//
//  SceneDelegate.swift
//  iOS Calculator
//
//  Created by Peter Lizak on 23/03/2020.
//  Copyright © 2020 Peter Lizak. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = DashboardViewController()
        self.window?.makeKeyAndVisible()
    }
}

