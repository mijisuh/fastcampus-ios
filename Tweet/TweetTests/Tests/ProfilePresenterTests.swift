//
//  ProfilePresenterTests.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class ProfilePresenterTests: XCTestCase {
    var sut: ProfilePresenter!
    var viewController: MockProfileViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockProfileViewController()
        
        sut = ProfilePresenter(viewController: viewController)
    }
    
    override func tearDown() {
        sut = nil
        
        viewController = nil
        
        super.tearDown()
    }
    
    func test_viewWillAppear() {
        sut.viewWillAppear()
        
        XCTAssertTrue(viewController.isCalledSetViews)
    }
    
    func test_viewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    // name이 존재하지 않을 때
    func test_didTapSaveButton_without_name() {
        sut.didTapSaveButton(name: nil, account: "app_developer")
        
        XCTAssertTrue(viewController.isCalledEndEditing)
        XCTAssertTrue(viewController.isCalledShowToast)
        XCTAssertFalse(viewController.isCalledSetViews)
    }
    // account가 존재하지 않을 때
    func test_didTapSaveButton_without_account() {
        sut.didTapSaveButton(name: "se0m", account: nil)
        
        XCTAssertTrue(viewController.isCalledEndEditing)
        XCTAssertTrue(viewController.isCalledShowToast)
        XCTAssertFalse(viewController.isCalledSetViews)
    }
    // name, account가 모두 존재하지 않을 때
    func test_didTapSaveButton_without_all() {
        sut.didTapSaveButton(name: nil, account: nil)
        
        XCTAssertTrue(viewController.isCalledEndEditing)
        XCTAssertTrue(viewController.isCalledShowToast)
        XCTAssertFalse(viewController.isCalledSetViews)
    }
    // name, account가 모두 존재할 때
    func test_didTapSaveButton_with_all() {
        sut.didTapSaveButton(name: "se0m", account: "app_developer")
        
        XCTAssertTrue(viewController.isCalledEndEditing)
        XCTAssertFalse(viewController.isCalledShowToast)
        XCTAssertTrue(viewController.isCalledSetViews)
    }
}

