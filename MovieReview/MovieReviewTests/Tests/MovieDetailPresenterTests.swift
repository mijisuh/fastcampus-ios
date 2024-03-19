//
//  MovieDetailPresenterTests.swift
//  MovieReviewTests
//
//  Created by mijisuh on 2024/03/19.
//

import XCTest

@testable import MovieReview

final class MovieDetailPresenterTests: XCTestCase {
    var sut: MovieDetailPresenter!
    var viewController: MockMovieDetailViewController!
    var userDefaultsManager: MockUserDefaultsManager!
    var movie = Movie(
        title: "",
        posters: "",
        actors: [:],
        directors: [:],
        repRatDate: ""
    )
    
    override func setUp() {
        super.setUp()
        
        viewController = MockMovieDetailViewController()
        userDefaultsManager = MockUserDefaultsManager()
        
        sut = MovieDetailPresenter(
            viewController: viewController,
            userDefaultsManager: userDefaultsManager,
            movie: movie
        )
    }
    
    override func tearDown() {
        sut = nil
        
        userDefaultsManager = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad가_호출되면() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupViews)
        XCTAssertTrue(viewController.isCalledSetRightBarButtonItem)
    }
    
    // isLiked가 true인 경우
    func test_didTapRightBarButtonItem가_호출될_때_isLiked가_true이면() {
        movie.isLiked = false
        sut = MovieDetailPresenter(
            viewController: viewController,
            userDefaultsManager: userDefaultsManager,
            movie: movie
        )
        sut.didTapRightBarButtonItem() // toggle
        
        XCTAssertTrue(viewController.isCalledSetRightBarButtonItem)
        XCTAssertTrue(userDefaultsManager.isCalledAddMovie)
        XCTAssertFalse(userDefaultsManager.isCalledRemoveMovie)
    }
    
    // isLiked가 false인 경우
    func test_didTapRightBarButtonItem가_호출될_때_isLiked가_false이면() {
        movie.isLiked = true
        sut = MovieDetailPresenter(
            viewController: viewController,
            userDefaultsManager: userDefaultsManager,
            movie: movie
        )
        sut.didTapRightBarButtonItem() // toggle
        
        XCTAssertTrue(viewController.isCalledSetRightBarButtonItem)
        XCTAssertFalse(userDefaultsManager.isCalledAddMovie)
        XCTAssertTrue(userDefaultsManager.isCalledRemoveMovie)
    }
}
