//
//  MovieDetailViewController.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieDetailViewController: UIViewController {
    private var presenter: MovieDetailPresenter!
    
    private lazy var rightBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "star"),
        style: .plain,
        target: self, // 초기화할 때 자신을 넣지 못하므로 lazy var로 선언
        action: #selector(didTapRightBarButtonItem)
    )
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        
        presenter = MovieDetailPresenter(viewController: self, movie: movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailProtocol {
    func setupViews(with movie: Movie) {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = movie.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if let imageURL = movie.imageURL {
            imageView.kf.setImage(with: imageURL)
        }
        
        let userRatingContentsStackView = MovieContentsStackView(
            title: "평점",
            contents: "5.0"
        )
        let actorContentsStackView = MovieContentsStackView(
            title: "배우",
            contents: movie.actorNames.joined(separator: ", ")
        )
        let directorContentsStackView = MovieContentsStackView(
            title: "감독",
            contents: movie.directorNames.joined(separator: ", ")
        )
        let pubDateContentsStackView = MovieContentsStackView(
            title: "제작년도",
            contents: movie.repRatDate
        )
        
        let contentsStackView = UIStackView(
            arrangedSubviews: [
                userRatingContentsStackView,
                actorContentsStackView,
                directorContentsStackView,
                pubDateContentsStackView
            ])
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 8.0
        
        [imageView, contentsStackView].forEach { view.addSubview($0) }
        
        let inset: CGFloat = 16.0
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(inset)
            $0.leading.trailing.equalToSuperview().inset(inset)
            $0.height.equalTo(imageView.snp.width)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(inset)
            $0.leading.trailing.equalTo(imageView)
        }
    }
    
    func setRightBarButtonItem(with isLiked: Bool) {
        let imageName = isLiked ? "star.fill" : "star"
        rightBarButtonItem.image = UIImage(systemName: imageName)
    }
}

private extension MovieDetailViewController {
    @objc func didTapRightBarButtonItem() {
        presenter.didTapRightBarButtonItem()
    }
}
