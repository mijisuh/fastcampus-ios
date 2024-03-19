//
//  MovieDetailViewController.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import UIKit
import SnapKit

final class MovieDetailViewController: UIViewController {
    private lazy var presenter = MovieDetailPresenter(viewController: self)
    
    private let rightBarButtonItem = UIBarButtonItem()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var userRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: <#T##CGFloat#>, weight: <#T##UIFont.Weight#>)
        
        return label
    }()
    
    private lazy var actorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: <#T##CGFloat#>, weight: <#T##UIFont.Weight#>)
        
        return label
    }()
    
    private lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: <#T##CGFloat#>, weight: <#T##UIFont.Weight#>)
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: <#T##CGFloat#>, weight: <#T##UIFont.Weight#>)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailProtocol {
    func setupNavigationBar() {
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupViews() {
        
    }
    
    func setupLayout() {
        
    }
}

private extension MovieDetailViewController {
    
}
