//
//  MockUserDefaultsManager.swift
//  MovieReviewTests
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

@testable import MovieReview

final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
    var isCalledGetMovies = false
    var isCalledAddMovie = false
    var isCalledRemoveMovie = false
    
    func getMovies() -> [MovieReview.Movie] {
        isCalledGetMovies = true
        return []
    }
    
    func addMovie(_ newValue: MovieReview.Movie) {
        isCalledAddMovie = true
    }
    
    func removeMovie(_ movie: MovieReview.Movie) {
        isCalledRemoveMovie = true
    }
}
