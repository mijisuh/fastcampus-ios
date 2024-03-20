//
//  FeedPresenter.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit

protocol FeedProtocol: AnyObject {
    func setupViews()
    func pushToTweetViewController(with tweet: Tweet)
    func presentToWriteViewController()
    func reloadTableView()
}

final class FeedPresenter: NSObject {
    private weak var viewController: FeedProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtocol?
    
    private var tweets: [Tweet] = []
    
    init(
        viewController: FeedProtocol,
        userDefaultsManager: UserDefaultsManagerProtocol? = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewWillAppear() {
        tweets = userDefaultsManager?.getTweets() ?? []
        viewController?.reloadTableView()
    }
    
    func viewDidLoad() {
        viewController?.setupViews()
    }
    
    func didTapWriteButton() {
        viewController?.presentToWriteViewController()
    }
}

extension FeedPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedTableViewCell.identifier,
            for: indexPath
        ) as? FeedTableViewCell
        else { return UITableViewCell() }
        cell.setup(tweet)
        return cell
    }
}

extension FeedPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        viewController?.pushToTweetViewController(with: tweet)
    }
}
