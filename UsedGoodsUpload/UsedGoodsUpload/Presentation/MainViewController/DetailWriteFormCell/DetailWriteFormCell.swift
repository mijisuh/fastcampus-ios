//
//  DetailWriteFormCell.swift
//  UsedGoodsUpload
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DetailWriteFormCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    let contentTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailWriteFormCellViewModel) {
        contentTextView.rx.text
            .bind(to: viewModel.contentValue)
            .disposed(by: disposeBag)
        
        contentTextView.rx.observe(UIColor.self, "textColor")
            .bind(to: viewModel.textColor)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        contentTextView.font = .systemFont(ofSize: 17)
        contentTextView.textColor = .secondaryLabel
        contentTextView.delegate = self
    }
    
    private func layout() {
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
    }
    
}

extension DetailWriteFormCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return } // placeHolder 상태일 때
        
        textView.text = nil // 텍스트를 지우고
        textView.textColor = .label // 텍스트 컬러를 검정색으로 변경
    }
    
}

