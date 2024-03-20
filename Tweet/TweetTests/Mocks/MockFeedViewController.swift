//
//  MockFeedViewController.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class MockFeedViewController: FeedProtocol {
    var isCalledSetupViews = false
    var isCalledPushToTweetViewController = false
    var isCalledPresentToWriteViewController = false
    var isCalledReloadTableView = false
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func pushToTweetViewController(with tweet: Tweet) {
        isCalledPushToTweetViewController = true
    }
    
    func presentToWriteViewController() {
        isCalledPresentToWriteViewController = true
    }
    
    func reloadTableView() {
        isCalledReloadTableView = true
    }
}
