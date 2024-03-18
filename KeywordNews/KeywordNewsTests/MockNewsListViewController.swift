//
//  MockNewsListViewController.swift
//  KeywordNewsTests
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

@testable import KeywordNews

final class MockNewsListViewController: NewsListProtocol {
    var isCalledSetupNavigationBar = false
    var isCalledSetupLayout = false
    var isCalledEndRefreshing = false
    var isCalledMoveToNewsWebViewController = false
    var isCalledReloadTableView = false
    
    func setupNavigationBar() {
        isCalledSetupNavigationBar = true
    }
    
    func setupLayout() {
        isCalledSetupLayout = true
    }
    
    func endRefreshing() {
        isCalledEndRefreshing = true
    }
    
    func moveToNewsWebViewController(with news: KeywordNews.News) {
        isCalledMoveToNewsWebViewController = true
    }
    
    func reloadTableView() {
        isCalledReloadTableView = true
    }
}
