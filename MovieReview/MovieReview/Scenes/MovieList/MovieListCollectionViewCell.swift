//
//  MovieListCollectionViewCell.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieListCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    func setup(image: String, title: String, rating: String) {
//        imageView.kf.setImage(with: image)
        titleLabel.text = title
        ratingLabel.text = rating
    }
}

private extension MovieListCollectionViewCell {
    func setupLayout() {
        [imageView, titleLabel, ratingLabel].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom)
        }
    }
}
