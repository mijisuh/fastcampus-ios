//
//  SceneDelegate.swift
//  Outstagram
//
//  Created by mijisuh on 2024/03/06.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = TabBarController()
        window?.tintColor = .label // Scene 자체에서 사용하는 모든 ViewController의 tintColor 설정
        window?.makeKeyAndVisible()
    }

}

