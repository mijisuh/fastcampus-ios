//
//  MockTweetViewController.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class MockTweetViewController: TweetProtocol {
    var isCalledSetupViews = false
    
    func setupViews() {
        isCalledSetupViews = true
    }
}
