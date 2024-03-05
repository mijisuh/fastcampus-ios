//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/05.
//

import UIKit
import SnapKit
import Kingfisher

final class AppDetailViewController: UIViewController {
    
    private let appTitle: String
    private let subTitle: String
    private let imageURL: String
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label // dark 모드에도 대응 가능한 색상
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    init(appTitle: String, subTitle: String, imageURL: String) {
        self.appTitle = appTitle
        self.subTitle = subTitle
        self.imageURL = imageURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupViews()
        
        titleLabel.text = appTitle
        subTitleLabel.text = subTitle
        if let imageURL = URL(string: imageURL) {
            appIconImageView.kf.setImage(with: imageURL)
        } else {
            appIconImageView.backgroundColor = .lightGray
        }
    }
    
}

// MARK: Private
private extension AppDetailViewController {
    
    func setupViews() {
        [
            appIconImageView,
            titleLabel,
            subTitleLabel,
            downloadButton,
            shareButton
        ].forEach { view.addSubview($0) }
        
        appIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(32)
            $0.height.equalTo(100)
            $0.width.equalTo(appIconImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(appIconImageView.snp.top)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        downloadButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(appIconImageView.snp.bottom)
            $0.height.equalTo(24)
            $0.width.equalTo(60)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.height.equalTo(32)
            $0.width.equalTo(32)
            $0.centerY.equalTo(downloadButton.snp.centerY)
        }
    }
    
    @objc func didTapShareButton() {
        let activityItems: [Any] = [appTitle]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
}
