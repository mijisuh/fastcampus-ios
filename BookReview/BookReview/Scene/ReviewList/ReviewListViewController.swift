//
//  ReviewListViewController.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import UIKit
import SnapKit

final class ReviewListViewController: UIViewController {
    private lazy var presenter = ReviewListPresenter(viewController: self) // self는 초기화되는 타이밍에 바로 넣으면 안됨 -> lazy

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = presenter
        tableView.rowHeight = 100.0
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad() // View가 Presenter에게 View가 보여질 것임으로 알림
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
}

extension ReviewListViewController: ReviewListProtocol {
    func setupNavigationBar() { // Presenter에 의해 실행되어야 함
        navigationItem.title = "도서 리뷰"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapRightBarButtonItem)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func presentToReviewWriteViewController() {
        let viewController = UINavigationController(rootViewController: ReviewWriteViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
 
private extension ReviewListViewController {
    @objc func didTapRightBarButtonItem() {
        presenter.didTapRightBarButtonItem()
    }
}
