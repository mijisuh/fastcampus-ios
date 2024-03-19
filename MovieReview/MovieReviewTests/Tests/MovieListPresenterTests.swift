//
//  MovieListPresenterTests.swift
//  MovieReviewTests
//
//  Created by mijisuh on 2024/03/19.
//

import XCTest

@testable import MovieReview

final class MovieListPresenterTests: XCTestCase {
    var sut: MovieListPresenter!
    var viewController: MockMovieListViewController!
    var movieSearchManager: MockMovieSearchManager!
    var userDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockMovieListViewController()
        movieSearchManager = MockMovieSearchManager()
        userDefaultsManager = MockUserDefaultsManager()
        
        sut = MovieListPresenter(
            viewController: viewController,
            movieSearchManager: movieSearchManager,
            userDefaultsManager: userDefaultsManager
        )
    }
    
    override func tearDown() {
        sut = nil
        
        userDefaultsManager = nil
        movieSearchManager = nil
        viewController = nil
        
        super.tearDown()
    }
    
    // Given이 있는 상황(분기 가능)
    // request 메서드가 성공하면 reloadTableView() 실행
    func test_searchBar_textDidChange가_호출될_때_request가_성공하면() {
        movieSearchManager.needToSuccessRequest = true
        sut.searchBar(UISearchBar(), textDidChange: "")
        
        XCTAssertTrue(viewController.isCalledReloadTableView, "reloadTableView()가 실행된다.")
    }
    // request 메서드가 실패하면 reloadTableView() 실행 X
    func test_searchBar_textDidChange가_호출될_때_request가_실패하면() {
        movieSearchManager.needToSuccessRequest = false
        sut.searchBar(UISearchBar(), textDidChange: "")
        
        XCTAssertTrue(viewController.isCalledReloadTableView, "reloadTableView()가 실행되지 않는다.")
    }
    
    // When, Then
    func test_viewDidLoad가_호출되면() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupNaviagtionBar)
        XCTAssertTrue(viewController.isCalledSetupSearchBar)
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_viewWillAppear가_호출되면() {
        sut.viewWillAppear()
        
        XCTAssertTrue(userDefaultsManager.isCalledGetMovies)
        XCTAssertTrue(viewController.isCalledReloadCollectionView)
    }
    
    func test_searchBarTextDidBeginEditing가_호출되면() {
        sut.searchBarTextDidBeginEditing(UISearchBar())
        
        XCTAssertTrue(viewController.isCalledUpdateTableView)
    }
    
    func test_searchBarCancelButtonClicked가_호출되면() {
        sut.searchBarCancelButtonClicked(UISearchBar())
        
        XCTAssertTrue(viewController.isCalledUpdateTableView)
        XCTAssertTrue(viewController.isCalledReloadTableView)
    }
}
