//
//  FeedViewController.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit
import SnapKit
import Floaty

final class FeedViewController: UIViewController {
    private lazy var presenter = FeedPresenter(viewController: self)
    
    private lazy var writeButton: Floaty = {
        let floaty = Floaty()
        floaty.sticky = true
        floaty.handleFirstItemDirectly = true // 버튼 클릭 시 세부 버튼이 나오지 않고 바로 동작
        floaty.addItem(title: "") { [weak self] _ in
            self?.didTapWriteButton()
        }
        floaty.buttonImage = Icon.write.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return floaty
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = presenter
        tableView.delegate = presenter
        tableView.register(
            FeedTableViewCell.self,
            forCellReuseIdentifier: FeedTableViewCell.identifier
        )
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension FeedViewController: FeedProtocol {
    func setupViews() {
        navigationItem.title = TabBarItem.feed.title
        
        [tableView, writeButton].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        writeButton.paddingY = 100.0
    }
    
    func pushToTweetViewController(with tweet: Tweet) {
        let viewController = TweetViewController(tweet: tweet)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentToWriteViewController() {
        let viewController = UINavigationController(rootViewController:  WriteViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true) // 아래에서 올라옴
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

private extension FeedViewController {
    func didTapWriteButton() {
        presenter.didTapWriteButton()
    }
}
