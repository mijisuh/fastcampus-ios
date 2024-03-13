//
//  CafeApp.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

@main
struct CafeApp: App { // AppDelegate, SceneDelegate와 동일한 역할(SwiftUI Life Cycle을 따름)
    var body: some Scene {
        WindowGroup {
            MainTabView() // 앱에 가장 기본으로 설정되는 화면
                .accentColor(.green) // 각 Preview에는 적용 X -> 시뮬레이터로 확인
        }
    }
}
