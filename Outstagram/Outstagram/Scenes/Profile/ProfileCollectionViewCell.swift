//
//  ProfileCollectionViewCell.swift
//  Outstagram
//
//  Created by mijisuh on 2024/03/06.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    func setup(with image: UIImage) {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    
        imageView.backgroundColor = .tertiaryLabel
    }
    
}
