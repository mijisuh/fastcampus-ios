//
//  TweetPresenterTests.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class TweetPresenterTests: XCTestCase {
    var sut: TweetPresenter!
    var viewController: MockTweetViewController!
    let tweet = Tweet(
        user: User(
            name: "seom",
            account: "ios_developer"
        ),
        contents: "안녕하세요!"
    )
    
    override func setUp() {
        super.setUp()
        
        viewController = MockTweetViewController()
        sut = TweetPresenter(viewController: viewController, tweet: tweet)
    }
    
    override func tearDown() {
        sut = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
}
