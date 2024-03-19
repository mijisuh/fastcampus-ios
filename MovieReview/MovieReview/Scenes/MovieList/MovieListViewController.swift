//
//  MovieListViewController.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import UIKit

final class MovieListViewController: UIViewController {
    private lazy var presenter = MovieListPresenter(viewController: self)
    
    private let searchController = UISearchController()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        collectionView.register(
            MovieListCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true // SearchBar가 활성화되기 전에는 안보임
        tableView.delegate = presenter
        tableView.dataSource = presenter
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

extension MovieListViewController: MovieListProtocol {
    func setupNaviagtionBar() {
        navigationItem.title = "영화 평점"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = presenter // 자동 완성
        navigationItem.searchController = searchController
    }
    
    func setupViews() {
        [collectionView, tableView].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateTableView(isHidden: Bool) {
        tableView.isHidden = isHidden
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func pushToMovieDetailViewController(with movie: Movie) {
        let viewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
