//
//  NewsListPresenter.swift
//  KeywordNews
//
//  Created by mijisuh on 2024/03/18.
//

import UIKit

protocol NewsListProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func endRefreshing()
}

final class NewsListPresenter: NSObject {
    private weak var viewController: NewsListProtocol?

    init(viewController: NewsListProtocol) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }
    
    func didCalledRefresh() {
        viewController?.endRefreshing() 
    }
}

extension NewsListPresenter: UITableViewDelegate {
     
}

extension NewsListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsListTableViewCell.identifier
        ) as? NewsListTableViewCell
        else { return UITableViewCell() }
        cell.setup()
        return cell
    }
}
