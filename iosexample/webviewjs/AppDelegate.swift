//
//  AppDelegate.swift
//  webviewjs
//
//  Created by zick on 2022/1/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.becomeFirstResponder()
        window?.makeKeyAndVisible()

        let vc = ViewController()
        let navC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navC

        return true
    }
}

