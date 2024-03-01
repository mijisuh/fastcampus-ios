//
//  ContentCollectionViewRankCell.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/03/02.
//

import UIKit

class ContentCollectionViewRankCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let rankLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // contentView
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        
        // imageView
        self.imageView.contentMode = .scaleToFill
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        // rankLabel
        self.rankLabel.font = .systemFont(ofSize: 100, weight: .black)
        self.rankLabel.textColor = .white
        self.contentView.addSubview(self.rankLabel)
        self.rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(25)
        }
    }
    
}
