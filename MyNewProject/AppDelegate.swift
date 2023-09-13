//
//  AppDelegate.swift
//  MyNewProject
//
//  Created by prem  on 13/09/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootNavigator : UINavigationController!

    func bootStrapHomeLoader() {
        //Navigate to the user at Loading Screen after the launching screen finished.
        window = UIWindow(frame: UIScreen.main.bounds)
        rootNavigator = UINavigationController(rootViewController: FirstViewController())
        rootNavigator.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = rootNavigator
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        bootStrapHomeLoader()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

