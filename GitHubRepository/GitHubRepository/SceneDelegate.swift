//
//  SceneDelegate.swift
//  GitHubRepository
//
//  Created by mijisuh on 2024/03/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let rootViewController = RepositoryListViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }

}

