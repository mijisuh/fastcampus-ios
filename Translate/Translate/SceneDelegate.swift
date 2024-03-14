//
//  SceneDelegate.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootViewController = TabBarController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootViewController
        window?.backgroundColor = .systemBackground
        window?.tintColor = UIColor.mainTintColor
        window?.makeKeyAndVisible()
    }
}

