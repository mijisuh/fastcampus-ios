//
//  MockMovieDetailViewController.swift
//  MovieReviewTests
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

@testable import MovieReview

final class MockMovieDetailViewController: MovieDetailProtocol {
    var isCalledSetupViews = false
    var isCalledSetRightBarButtonItem = false
    
    var settedIsLiked = false
    
    func setupViews(with movie: MovieReview.Movie) {
        isCalledSetupViews = true
    }
    
    func setRightBarButtonItem(with isLiked: Bool) {
        isCalledSetRightBarButtonItem = true
        settedIsLiked = isLiked
    }
}
