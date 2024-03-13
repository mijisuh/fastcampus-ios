//
//  HomeViewModel.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

class HomeViewModel: ObservableObject { // ObservableObject은 class로 정의해야 함
    @Published var isNeedToReload = false {
        didSet {
            guard isNeedToReload else { return }
            coffeeMenu.shuffle()
            events.shuffle()
            isNeedToReload = false
        }
    }
    
    @Published var coffeeMenu: [CoffeeMenu] = [
        CoffeeMenu(image: Image("coffee"), name: "아메리카노"),
        CoffeeMenu(image: Image("coffee"), name: "아이스 아메리카노"),
        CoffeeMenu(image: Image("coffee"), name: "카페라떼"),
        CoffeeMenu(image: Image("coffee"), name: "아이스 카페라떼"),
        CoffeeMenu(image: Image("coffee"), name: "드립커피"),
        CoffeeMenu(image: Image("coffee"), name: "아이스 드립커피"),
    ]
    
    @Published var events: [Event] = [
        Event(image: Image("coffee"), title: "제주도 한정 메뉴", description: "제주도 한정 음료가 출시되었습니다! 꼭 드셔보세요."),
        Event(image: Image("coffee"), title: "여름 한정 메뉴", description: "여름이니까 아이스 커피 ~")
    ]
}
