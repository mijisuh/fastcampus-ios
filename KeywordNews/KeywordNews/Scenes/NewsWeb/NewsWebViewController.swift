//
//  NewsWebViewController.swift
//  KeywordNews
//
//  Created by mijisuh on 2024/03/18.
//

import UIKit
import SnapKit
import WebKit

final class NewsWebViewController: UIViewController {
    private let rightBarButtonitem = UIBarButtonItem(
        image: UIImage(systemName: "link"),
        style: .plain,
        target: NewsWebViewController.self,
        action: #selector(didTapRightBarButtonItem)
    )
    
    private let webView = WKWebView()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupWebView()
    }
}

private extension NewsWebViewController {
    func setupNavigationBar() {
        navigationItem.title = "기사 제목"
        navigationItem.rightBarButtonItem = rightBarButtonitem
    }
    
    func setupWebView() {
        guard let linkURL = URL(string: "https://fastcampus.co.kr/") else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        view = webView
        
        let urlRequest = URLRequest(url: linkURL)
        webView.load(urlRequest)
    }
    
    @objc func didTapRightBarButtonItem() {
        UIPasteboard.general.string = "뉴스 링크"
    }
}
