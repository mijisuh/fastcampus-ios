//
//  DetailListBackgroundView.swift
//  FindCVS
//
//  Created by mijisuh on 2024/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DetailListBackgroundView: UIView {
    
    let disposeBag = DisposeBag()
    
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailListBackgroundViewModel) {
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden) // isStatusLabelHidden을 statusLabel.isHidden과 연결
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        backgroundColor = .systemBackground
        
        statusLabel.text = "🏪"
        statusLabel.textAlignment = .center
    }
    
    private func layout() {
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
}
