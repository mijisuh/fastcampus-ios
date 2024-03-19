//
//  MovieDetailPresenter.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

protocol MovieDetailProtocol: AnyObject {
    func setupViews(with movie: Movie)
    func setRightBarButtonItem(with isLiked: Bool)
}

final class MovieDetailPresenter: NSObject {
    private weak var viewController: MovieDetailProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    private var movie: Movie
    
    init(
        viewController: MovieDetailProtocol,
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager(),
        movie: Movie
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
        self.movie = movie
    }
    
    func viewDidLoad() {
        viewController?.setupViews(with: movie)
        viewController?.setRightBarButtonItem(with: movie.isLiked)
    }
    
    func didTapRightBarButtonItem() {
        movie.isLiked.toggle()
        viewController?.setRightBarButtonItem(with: movie.isLiked)
        
        if movie.isLiked {
            userDefaultsManager.addMovie(movie)
        } else {
            userDefaultsManager.removeMovie(movie)
        }
    }
}
