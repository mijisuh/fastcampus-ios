//
//  TodayCollectionViewCell.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit
import SnapKit
import Kingfisher

final class TodayCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // 이미지 뷰의 크기보다 이미지가 크면 이미지 뷰의 범위를 벗어나서 표시되기 때문에 true로 설정해야 함
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    func setup(today: Today) {
        // 그림자 설정
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        
        setupSubViews()
        
        subTitleLabel.text = today.subTitle
        titleLabel.text = today.title
        descriptionLabel.text = today.description
        
        // imageView.image를 url로 바로 주입시킬 수 없으므로 KingFisher 모듈 활용
        if let imageURL = URL(string: today.imageURL) {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
}

private extension TodayCollectionViewCell {
    
    func setupSubViews() {
        [imageView, titleLabel, subTitleLabel, descriptionLabel].forEach { addSubview($0) }
        
        // Inset 설정
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(subTitleLabel)
            $0.trailing.equalTo(subTitleLabel)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(4)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
