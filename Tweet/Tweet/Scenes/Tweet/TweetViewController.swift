//
//  TweetViewController.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit

final class TweetViewController: UIViewController {
    private var presenter: TweetPresenter?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 30.0
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .medium)
        return label
    }()
    
    private lazy var userAccountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.like.image, for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.share.image, for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    init(tweet: Tweet) {
        super.init(nibName: nil, bundle: nil)
        
        presenter = TweetPresenter(viewController: self, tweet: tweet)
        
        userNameLabel.text = tweet.user.name
        userAccountLabel.text = "@\(tweet.user.account)"
        contentsLabel.text = tweet.contents
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
}

extension TweetViewController: TweetProtocol {
    func setupViews() {
        navigationItem.title = ""
        
        view.backgroundColor = .systemBackground
        
        let userStackView = UIStackView(arrangedSubviews: [userNameLabel, userAccountLabel])
        userStackView.axis = .vertical
        userStackView.distribution = .equalSpacing
        userStackView.spacing = 4.0
        
        let buttonStackView = UIStackView(arrangedSubviews: [likeButton, shareButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        [
            profileImageView,
            userStackView,
            contentsLabel,
            buttonStackView
        ].forEach { view.addSubview($0) }
        
        let superViewMargin: CGFloat = 16.0
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(superViewMargin)
            $0.leading.equalToSuperview().inset(superViewMargin)
            $0.width.equalTo(60.0)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        userStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(superViewMargin)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8.0)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalTo(userStackView)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(superViewMargin)
            $0.leading.trailing.equalTo(contentsLabel)
        }
    }
}

