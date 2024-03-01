//
//  UIButton.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/03/02.
//

import UIKit

extension UIButton {
    
    func adjustVerticalLayout(_ spacing: CGFloat = 0) { // 이미지와 라벨 사이의 간격 사이즈 지정
        let imageViewSize = self.imageView?.frame.size ?? .zero
        let titleLabelSize = self.titleLabel?.frame.size ?? .zero
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageViewSize.width, bottom: -(imageViewSize.height + spacing), right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleLabelSize.height + spacing), left: 0, bottom: 0, right: -titleLabelSize.width)
    }
    
}
