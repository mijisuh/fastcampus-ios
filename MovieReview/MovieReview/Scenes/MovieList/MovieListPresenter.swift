//
//  MovieListPresenter.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import UIKit

protocol MovieListPresenterProtocol: AnyObject {
    func setupNaviagtionBar()
    func setupSearchBar()
    func setupViews()
}

final class MovieListPresenter: NSObject {
    private weak var viewController: MovieListPresenterProtocol?
    
    init(viewController: MovieListPresenterProtocol?) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupNaviagtionBar()
        viewController?.setupSearchBar()
        viewController?.setupViews()
    }
}

extension MovieListPresenter: UICollectionViewDelegate {
    
}

extension MovieListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieListCollectionViewCell.identifier,
            for: indexPath
        ) as? MovieListCollectionViewCell
        else { return UICollectionViewCell() }
        
        return cell
    }
}

extension MovieListPresenter: UITableViewDelegate {
    
}

extension MovieListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension MovieListPresenter: UISearchBarDelegate {
    
}
