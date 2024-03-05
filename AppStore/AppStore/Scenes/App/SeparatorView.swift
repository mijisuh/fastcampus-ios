//
//  Separator.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit
import SnapKit

final class SeparatorView: UIView {
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .separator // UITableView의 separator와 동일한 색상
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
