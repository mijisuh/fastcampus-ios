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
    func moveToNewsWebViewController(with news: News)
    func reloadTableView()
}

final class NewsListPresenter: NSObject {
    private weak var viewController: NewsListProtocol?
    private let newsSearchManager: NewsSearchManagerProtocol
    
    private var currentKeyword = ""
    private var currentPage: Int = 0 // 지금까지 request해서 보여주고 있는 page가 어디인지
    private let display: Int = 20 // 한 페이지에 최대 몇 개까지 보여줄 것인지
    
    private let tags: [String] = ["IT", "아이폰", "개발", "개발자", "판교", "게임", "앱개발", "강남", "스타트업"]
    
    private var newsList: [News] = []

    init(
        viewController: NewsListProtocol,
        newsSearchManager: NewsSearchManagerProtocol = NewsSearchManager()
    ) {
        self.viewController = viewController
        self.newsSearchManager = newsSearchManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }
    
    func didCalledRefresh() {
        requestNewsList(isNeededToReset: true)
    }
}

extension NewsListPresenter: NewsListTableViewHeaderViewProtocol {
    func didSelectTag(_ selectedIndex: Int) {
        currentKeyword = tags[selectedIndex]
        requestNewsList(isNeededToReset: true)
    }
}

extension NewsListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        viewController?.moveToNewsWebViewController(with: news)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentRow = indexPath.row
        
        guard currentRow % display == display - 3, // 뒤에서 3번째 셀이고
              currentRow / display == currentPage - 1 // 마지막 페이지일 때
        else { return }
        
        requestNewsList(isNeededToReset: false)
    }
}

extension NewsListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsListTableViewCell.identifier
        ) as? NewsListTableViewCell
        else { return UITableViewCell() }
        let news = newsList[indexPath.row]
        cell.setup(news: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsListTableViewHeaderView.identifier
        ) as? NewsListTableViewHeaderView
        else { return UITableViewHeaderFooterView() }
        header.setup(tags: tags, delegate: self)
        return header
    }
}

private extension NewsListPresenter {
    func requestNewsList(isNeededToReset: Bool) {
        if isNeededToReset {
            currentPage = 0
            newsList = []
        }
        
        newsSearchManager.request(
            from: currentKeyword,
            start: currentPage * display + 1,
            display: display
        ) { [weak self] newValue in
            self?.newsList += newValue // 페이지 추가
            self?.currentPage += 1 // 스크롤이 될 때마다 새로운 페이지로 갱신이 되고 새로운 데이터가 추가됨
            self?.viewController?.reloadTableView()
            self?.viewController?.endRefreshing()
        }
    }
 }
