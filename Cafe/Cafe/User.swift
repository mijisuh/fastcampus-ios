//
//  User.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import Foundation

struct User {
    let username: String
    let account: String
    
    static let shared = User(username: "seom", account: "seom@gmail.com")
}
