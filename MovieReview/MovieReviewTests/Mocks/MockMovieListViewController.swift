//
//  MockMovieListViewController.swift
//  MovieReviewTests
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

@testable import MovieReview

final class MockMovieListViewController: MovieListProtocol {
    var isCalledSetupNaviagtionBar = false
    var isCalledSetupSearchBar = false
    var isCalledSetupViews = false
    var isCalledUpdateTableView = false
    var isCalledReloadTableView = false
    var isCalledPushToMovieDetailViewController = false
    var isCalledReloadCollectionView = false
    
    func setupNaviagtionBar() {
        isCalledSetupNaviagtionBar = true
    }
    
    func setupSearchBar() {
        isCalledSetupSearchBar = true
    }
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func updateTableView(isHidden: Bool) {
        isCalledUpdateTableView = true
    }
    
    func reloadTableView() {
        isCalledReloadTableView = true
    }
    
    func pushToMovieDetailViewController(with movie: MovieReview.Movie) {
        isCalledPushToMovieDetailViewController = true
    }
    
    func reloadCollectionView() {
        isCalledReloadCollectionView = true
    }
}
