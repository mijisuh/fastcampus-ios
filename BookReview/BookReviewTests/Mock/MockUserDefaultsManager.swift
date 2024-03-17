//
//  MockUserDefaultsManager.swift
//  BookReviewTests
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

@testable import BookReview

final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
    var isCalledGetReviews = false
    var isCalledSetReview = false
    
    func getReviews() -> [BookReview] {
        isCalledGetReviews = true
        
        return []
    }
    
    func setReview(_ newValue: BookReview) {
        isCalledSetReview = true
    }
} 
