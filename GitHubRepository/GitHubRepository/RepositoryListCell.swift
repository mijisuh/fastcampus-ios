//
//  RepositoryListCell.swift
//  GitHubRepository
//
//  Created by mijisuh on 2024/03/08.
//

import UIKit
import SnapKit

final class RepositoryListCell: UITableViewCell {
    
    var repository: Repository?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    
    private lazy var starLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            nameLabel,
            descriptionLabel,
            starImageView,
            starLabel,
            languageLabel
        ].forEach { contentView.addSubview($0) }
        
        guard let repository = repository else { return }
        
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        starLabel.text = "\(repository.starGazersCount)"
        languageLabel.text = repository.language
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        starImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(descriptionLabel)
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        starLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starImageView.snp.trailing).offset(5)
        }
        
        languageLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starLabel.snp.trailing).offset(12)
        }
    }
    
}

