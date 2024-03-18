//
//  NewsListTableViewCell.swift
//  KeywordNews
//
//  Created by mijisuh on 2024/03/18.
//

import UIKit
import SnapKit

final class NewsListTableViewCell: UITableViewCell {
    static let identifier = "NewsListTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        return label
    }()
    
    private lazy var dateLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    func setup() {
        setupLayout()
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator // 이동
        
        titleLabel.text = "기사제목"
        descriptionLabel.text = "기사내용"
        dateLable.text = "2024.03.18"
    }
}

private extension NewsListTableViewCell {
    func setupLayout() {
        [titleLabel, descriptionLabel, dateLable].forEach { addSubview($0) }
        
        let verticalSpacing: CGFloat = 4.0
        let superViewInsets: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(superViewInsets)
            $0.trailing.equalToSuperview().inset(48.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(verticalSpacing)
        }
        
        dateLable.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(verticalSpacing)
            $0.bottom.equalToSuperview().inset(superViewInsets)
        }
    }
}
