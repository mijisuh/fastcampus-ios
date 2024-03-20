//
//  TweetPresenter.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit

protocol TweetProtocol: AnyObject {
    func setupViews()
}

final class TweetPresenter: NSObject {
    private weak var viewController: TweetProtocol?
    
    private let tweet: Tweet
    
    init(
        viewController: TweetProtocol?,
        tweet: Tweet
    ) {
        self.viewController = viewController
        self.tweet = tweet
    }
    
    func viewDidLoad() {
        viewController?.setupViews()
    }
}
