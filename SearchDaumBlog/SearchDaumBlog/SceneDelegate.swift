//
//  SceneDelegate.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let rootViewController = MainViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }

}

