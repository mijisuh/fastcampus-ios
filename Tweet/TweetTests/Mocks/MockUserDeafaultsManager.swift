//
//  MockUserDeafaultsManager.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class MockUserDeafaultsManager: UserDefaultsManagerProtocol {
    var tweets: [Tweet] = []
    var newTweet: Tweet!
    
    var isCalledGetTweets = false
    var isCalledSetTweet = false
    
    func getTweets() -> [Tweet] {
        isCalledGetTweets = true
        return tweets
    }
    
    func setTweet(_ tweet: Tweet) {
        isCalledSetTweet = true
        self.newTweet = tweet
    }
}
