//
//  TabBarController.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit

class TabBarController: UITabBarController {
    
    private lazy var todayViewController: UIViewController = {
        let viewController = TodayViewController()
        let tabBarItem = UITabBarItem(
            title: "투데이",
            image: UIImage(systemName: "mail"),
            tag: 0
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var appViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: AppViewController())
        let tabBarItem = UITabBarItem(
            title: "앱",
            image: UIImage(systemName: "square.stack.3d.up"),
            tag: 1
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITabBarController는 기본적으로 viewControllers라는 프로퍼티를 가지고 있음
        // 탭에서 표시할 뷰 컨트롤러
        viewControllers = [todayViewController, appViewController]
    }

}

