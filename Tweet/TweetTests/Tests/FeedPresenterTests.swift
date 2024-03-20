//
//  FeedPresenterTests.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class FeedPresenterTests: XCTestCase {
    var sut: FeedPresenter!
    var viewController: MockFeedViewController!
    var userDefaultsManager: MockUserDeafaultsManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockFeedViewController()
        userDefaultsManager = MockUserDeafaultsManager()
        
        sut = FeedPresenter(viewController: viewController, userDefaultsManager: userDefaultsManager)
    }
    
    override func tearDown() {
        sut = nil
        
        userDefaultsManager = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func test_viewWillAppear() {
        sut.viewWillAppear()
        
        XCTAssertTrue(userDefaultsManager.isCalledGetTweets)
        XCTAssertTrue(viewController.isCalledReloadTableView)
    }
    
    func test_viewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_didTapWriteButton() {
        sut.didTapWriteButton()
        
        XCTAssertTrue(viewController.isCalledPresentToWriteViewController)
    }
}
