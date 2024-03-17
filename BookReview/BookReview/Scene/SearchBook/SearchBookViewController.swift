//
//  SearchBookViewController.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import UIKit
import SnapKit

final class SearchBookViewController: UIViewController {
    private lazy var presenter = SearchBookPresenter(
        viewController: self,
        delegate: searchBookDelegate
    )
    
    private let searchBookDelegate: SearchBookDelegate
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = presenter
        tableView.delegate = presenter
        return tableView
    }()
    
    init(searchBookDelegate: SearchBookDelegate) {
        self.searchBookDelegate = searchBookDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension SearchBookViewController: SearchBookProtocol {
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = presenter // 데이터 핸들링
        
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func dismiss() {
        navigationItem.searchController?.dismiss(animated: true) // 두번 눌러야 dismiss 되는 문제 해결
        dismiss(animated: true)
    }
    
    func reloadView() {
        tableView.reloadData()
    }
}
