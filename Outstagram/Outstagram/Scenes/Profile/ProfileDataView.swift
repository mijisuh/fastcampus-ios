//
//  ProfileDataView.swift
//  Outstagram
//
//  Created by mijisuh on 2024/03/06.
//

import UIKit
import SnapKit

final class ProfileDataView: UIView {
    
    private let title: String
    private let count: Int
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.text = title
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "\(count)"
        return label
    }()
    
    init(title: String, count: Int) {
        self.title = title
        self.count = count
        
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProfileDataView {
    
    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
}
