//
//  ReviewListPresenterTests.swift
//  BookReviewTests
//
//  Created by mijisuh on 2024/03/17.
//

import XCTest
@testable import BookReview

final class ReviewListPresenterTests: XCTestCase {
    var sut: ReviewListPresenter! // sut: 테스트 대상
    var viewController: MockReviewListViewController!
    var userDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() { // 각각의 테스트 항목이 실행될 때 실행
        super.setUp()
        viewController = MockReviewListViewController()
        userDefaultsManager = MockUserDefaultsManager()
        sut = ReviewListPresenter(
            viewController: viewController,
            userDefaultsManager: userDefaultsManager
        )
    }
    
    override func tearDown() { // 각각의 테스트 항목이 종료될 때 실행
        sut = nil
        viewController = nil
        userDefaultsManager = nil
        
        super.tearDown()
    }

    // 테스트 항목(이름의 어두가 test- 여야 함)
    func test_viewDidLoad가_호출될_때() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_viewWillAppear가_호출될_때() {
        sut.viewWillAppear()
        
        XCTAssertTrue(userDefaultsManager.isCalledGetReviews)
        XCTAssertTrue(viewController.isCalledReloadTableView)
    }
    
    func test_didTapRightBarButtonItem가_호출될_때() {
        sut.didTapRightBarButtonItem()
        
        XCTAssertTrue(viewController.isCalledPresentToReviewWriteViewController)
    }
}
