//
//  AppDelegate.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
    
#if targetEnvironment(macCatalyst)
// MARK: - Menu Bar

extension AppDelegate {
    override func buildMenu(with builder: UIMenuBuilder) {
        builder.insertChild(UIMenu(title: "Stopwatch", image: nil, identifier: nil, options: .displayInline, children: [
            UIKeyCommand(title: "Start/Stop", action: #selector(toggleRunning), input: " "),
            UIKeyCommand(title: "Reset", action: #selector(resetTimer), input: "R", modifierFlags: .command)
        ]), atStartOfMenu: .file)
        
        builder.remove(menu: .edit)
        builder.remove(menu: .format)
        builder.remove(menu: .view)
    }

    @objc func toggleRunning() {
        if Stopwatch.shared.state == .stopped { // Start button
            Stopwatch.shared.start()
        } else { // Resume/Pause button
            Stopwatch.shared.togglePause()
        }
    }
    
    @objc func resetTimer() {
        Stopwatch.shared.reset()
    }
}
#endif
