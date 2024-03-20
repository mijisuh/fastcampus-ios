//
//  FeedTableViewCell.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit
import SnapKit

final class FeedTableViewCell: UITableViewCell {
    static let identifier = "FeedTableViewCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 21.0
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        return label
    }()
    
    private lazy var userAccountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.like.image, for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.message.image, for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.share.image, for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    func setup(_ tweet: Tweet) {
        selectionStyle = .none
        
        setupLayout()
        
        userNameLabel.text = tweet.user.name
        userAccountLabel.text = "@\(tweet.user.account)"
        contentsLabel.text = tweet.contents
    }
}

private extension FeedTableViewCell {
    func setupLayout() {
        let buttonStackView = UIStackView(
            arrangedSubviews: [likeButton, commentButton, shareButton]
        )
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        [
            profileImageView,
            userNameLabel,
            userAccountLabel,
            contentsLabel,
            buttonStackView
        ].forEach { addSubview($0) }
        
        let superViewMargin: CGFloat = 16.0
        profileImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(superViewMargin)
            $0.width.equalTo(40)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(superViewMargin)
            $0.top.equalTo(profileImageView)
        }
        
        userAccountLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(2.0)
            $0.bottom.equalTo(userNameLabel.snp.bottom)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4.0)
            $0.trailing.equalToSuperview().inset(superViewMargin)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.trailing.equalTo(contentsLabel)
            $0.top.equalTo(contentsLabel.snp.bottom).offset(12.0)
            $0.bottom.equalToSuperview().inset(superViewMargin)
        }
    }
}
