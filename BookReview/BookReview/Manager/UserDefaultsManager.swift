//
//  UserDefaultsManager.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func getReviews() -> [BookReview]
    func setReview(_ newValue: BookReview)
}

struct UserDefaultsManager: UserDefaultsManagerProtocol {
    enum Key: String {
        case review
    }
    
    func getReviews() -> [BookReview] {
        guard let data = UserDefaults.standard.data(forKey: Key.review.rawValue) else { return [] }
        return (try? PropertyListDecoder().decode([BookReview].self, from: data)) ?? []
    }
    
    func setReview(_ newValue: BookReview) {
        var currentReviews = getReviews()
        currentReviews.insert(newValue, at: 0) // 맨 위에 추가
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(currentReviews), forKey: Key.review.rawValue)
    }
}

