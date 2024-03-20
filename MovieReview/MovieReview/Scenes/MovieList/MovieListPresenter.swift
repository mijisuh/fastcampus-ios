//
//  MovieListPresenter.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import UIKit

protocol MovieListProtocol: AnyObject {
    func setupNaviagtionBar()
    func setupSearchBar()
    func setupViews()
    func updateTableView(isHidden: Bool)
    func reloadTableView()
    func pushToMovieDetailViewController(with movie: Movie)
    func reloadCollectionView()
}

final class MovieListPresenter: NSObject {
    private weak var viewController: MovieListProtocol?
    
    private let movieSearchManager: MovieSearchManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    private var likedMovies: [Movie] = []
    private var movieList: [Movie] = []
    
    init(
        viewController: MovieListProtocol?,
        movieSearchManager: MovieSearchManagerProtocol = MovieSearchManager(),
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.movieSearchManager = movieSearchManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewWillAppear() {
        likedMovies = userDefaultsManager.getMovies()
        viewController?.reloadCollectionView()
    }
    
    func viewDidLoad() {
        viewController?.setupNaviagtionBar()
        viewController?.setupSearchBar()
        viewController?.setupViews()
    }
}

extension MovieListPresenter: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 16.0
        let width: CGFloat = (collectionView.frame.width - spacing * 3) / 2
        return CGSize(width: width, height: 210.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let inset: CGFloat = 16.0
        return UIEdgeInsets(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
    }
}

extension MovieListPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = likedMovies[indexPath.item]
        viewController?.pushToMovieDetailViewController(with: movie)
    }
}

extension MovieListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        likedMovies.count
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
        cell.update(likedMovies[indexPath.row])
        return cell
    }
}

extension MovieListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieList[indexPath.row]
        viewController?.pushToMovieDetailViewController(with: movie)
    }
}

extension MovieListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(movieList[indexPath.row].trimmedTitle)"
        return cell
    }
}

extension MovieListPresenter: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewController?.updateTableView(isHidden: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieList = []
        viewController?.updateTableView(isHidden: true)
        viewController?.reloadTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            movieList = []
            viewController?.reloadTableView()
            return
        }
        movieSearchManager.request(from: searchText) { [weak self] movies in
            self?.movieList = movies
            self?.viewController?.reloadTableView()
        }
    }
}
