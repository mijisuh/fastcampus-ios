//
//  ContentCollectionViewCell.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/02/29.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 셀의 레이아웃에는  기본 셀이 있고 contentView라는 기본 객체가 있음
        // contentView를 superView로 보고 그 안에 subView 추가
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        
        self.imageView.contentMode = .scaleToFill
        
        self.contentView.addSubview(self.imageView)
        
        // imageView AutoLayout 설정
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
