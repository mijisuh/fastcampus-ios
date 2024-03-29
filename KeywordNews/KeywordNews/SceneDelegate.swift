//
//  SceneDelegate.swift
//  KeywordNews
//
//  Created by mijisuh on 2024/03/18.
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
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.tintColor = .systemOrange
        window?.rootViewController = UINavigationController(rootViewController: NewsListViewController())
        window?.makeKeyAndVisible()
    }
}
