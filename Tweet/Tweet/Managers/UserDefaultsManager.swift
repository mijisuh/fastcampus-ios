//
//  UserDefaultsManager.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func getTweets() -> [Tweet]
    func setTweet(_ tweet: Tweet)
}

struct UserDefaultsManager: UserDefaultsManagerProtocol {
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case tweet
        
        var value: String { self.rawValue } // associate value
    }
    
    func getTweets() -> [Tweet] {
        guard let data = userDefaults.data(forKey: Key.tweet.value) else { return [] }
        return (try? PropertyListDecoder().decode([Tweet].self, from: data)) ?? []
    }
    
    func setTweet(_ tweet: Tweet) {
        var tweets = getTweets()
        tweets.insert(tweet, at: 0)
        userDefaults.set(try? PropertyListEncoder().encode(tweets), forKey: Key.tweet.value)
    }
}
