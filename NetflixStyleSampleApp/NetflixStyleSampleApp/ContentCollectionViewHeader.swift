//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/02/29.
//

import UIKit
import SnapKit

class ContentCollectionViewHeader: UICollectionReusableView {
    
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        self.sectionNameLabel.textColor = .white
        self.sectionNameLabel.sizeToFit()
        
        self.addSubview(sectionNameLabel)
        
        self.sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
    
}
