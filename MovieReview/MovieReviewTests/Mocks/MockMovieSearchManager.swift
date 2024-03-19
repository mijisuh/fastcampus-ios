//
//  MockMovieSearchManager.swift
//  MovieReviewTests
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

@testable import MovieReview

final class MockMovieSearchManager: MovieSearchManagerProtocol {
    var isCalledRequest = false
    var needToSuccessRequest = false
    
    func request(from keyword: String, completionHandler: @escaping ([MovieReview.Movie]) -> Void) {
        isCalledRequest = true
        
        if needToSuccessRequest {
            completionHandler([])
        }
    }
}
