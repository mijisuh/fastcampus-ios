//
//  WritePresenterTests.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class WritePresenterTests: XCTestCase {
    var sut: WritePresenter!
    var viewController: MockWriteViewController!
    var userDefaultsManager: MockUserDeafaultsManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockWriteViewController()
        userDefaultsManager = MockUserDeafaultsManager()
        
        sut = WritePresenter(viewController: viewController, userDefaultsManager: userDefaultsManager)
    }
    
    override func tearDown() {
        sut = nil
        
        userDefaultsManager = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_didTapLeftBarButtonItem() {
        sut.didTapLeftBarButtonItem()
        
        XCTAssertTrue(viewController.isCalledDismiss)
    }
    
    func test_didTapRightBarButtonItem() {
        sut.didTapRightBarButtonItem(text: "하하")
        
        XCTAssertTrue(userDefaultsManager.isCalledSetTweet)
        XCTAssertTrue(viewController.isCalledDismiss)
    }
}

