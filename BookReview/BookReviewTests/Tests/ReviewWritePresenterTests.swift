//
//  ReviewWritePresenterTests.swift
//  BookReviewTests
//
//  Created by mijisuh on 2024/03/18.
//

import XCTest

@testable import BookReview

final class ReviewWritePresenterTests: XCTestCase {
    var sut: ReviewWritePresenter!
    var viewController: MockReviewWriteViewController!
    var userDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockReviewWriteViewController()
        userDefaultsManager = MockUserDefaultsManager()
        
        sut = ReviewWritePresenter(viewController: viewController, userDefaultsManager: userDefaultsManager)
    }
    
    override func tearDown() {
        sut = nil
        viewController = nil
        userDefaultsManager = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad가_호출될_때() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_didTapLeftBarButtonItem이_호출될_때() {
        sut.didTapLeftBarButtonItem()
        
        XCTAssertTrue(viewController.isCalledShowCloseAlertController)
    }
    
    func test_didTapRightBarButtonItem이_호출될_때_book이_존재하지_않으면() {
        sut.book = nil // 임의의 값을 주입
        sut.didTapRightBarButtonItem(contentsText: "참 공부하기 좋은 책이에요!")
        
        XCTAssertTrue(viewController.isCalledClose)
        XCTAssertFalse(userDefaultsManager.isCalledSetReview)
    }
    
    func test_didTapRightBarButtonItem이_호출될_때_book이_존재하고_contentsText가_존재하지_않으면() {
        sut.book = Book(title: "Swift", image: nil) // 임의의 값을 주입
        sut.didTapRightBarButtonItem(contentsText: nil)
        
        XCTAssertTrue(viewController.isCalledClose)
        XCTAssertFalse(userDefaultsManager.isCalledSetReview)
    }
    
    func test_didTapRightBarButtonItem이_호출될_때_book이_존재하고_contentsText가_placeHolder와_같으면() {
        sut.book = Book(title: "Swift", image: nil) // 임의의 값을 주입
        sut.didTapRightBarButtonItem(contentsText: sut.contentsTextViewPlaceHolder)
        
        XCTAssertTrue(viewController.isCalledClose)
        XCTAssertFalse(userDefaultsManager.isCalledSetReview)
    }
    
    func test_didTapRightBarButtonItem이_호출될_때_book이_존재하고_contentsText가_placeHolder와_같지않으면() {
        sut.book = Book(title: "Swift", image: nil) // 임의의 값을 주입
        sut.didTapRightBarButtonItem(contentsText: "참 공부하기 좋은 책이에요!")
        
        XCTAssertTrue(viewController.isCalledClose)
        XCTAssertTrue(userDefaultsManager.isCalledSetReview)
    }
    
    func test_didTapBookTitleButton이_호출될_때() {
        sut.didTapBookTitleButton()
        
        XCTAssertTrue(viewController.isCalledPresentToSearchBookViewController)
    }
}
