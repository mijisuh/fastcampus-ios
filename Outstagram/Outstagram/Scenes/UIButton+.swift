//
//  UIButton+.swift
//  Outstagram
//
//  Created by mijisuh on 2024/03/06.
//

import UIKit

extension UIButton {
    
    // SF Symbols의 크기가 서로 달라 버튼의 크기가 달라보이는 문제 해결
    func setImage(systemName: String) {
        // 가로, 세로 정렬
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
    
}
