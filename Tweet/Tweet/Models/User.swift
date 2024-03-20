//
//  User.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import Foundation

struct User: Codable {
    var name: String
    var account: String
    
    static var shared = User(name: "seom", account: "ios_developer") // 전역적으로 사용
}
