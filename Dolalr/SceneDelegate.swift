//
//  SceneDelegate.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        
        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 500, height: 480)
        windowScene.sizeRestrictions?.maximumSize = windowScene.sizeRestrictions!.minimumSize
        
        #if targetEnvironment(macCatalyst)
        windowScene.titlebar?.toolbar?.isVisible = false
        windowScene.titlebar?.titleVisibility = .hidden
        #endif
    }
}

