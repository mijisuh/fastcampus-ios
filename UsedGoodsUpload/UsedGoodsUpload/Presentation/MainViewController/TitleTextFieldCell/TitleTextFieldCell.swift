//
//  TitleTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit
import RxSwift
import RxCocoa

final class TitleTextFieldCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    let titleTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TitleTextFieldCellViewModel) {
        titleTextField.rx.text
            .bind(to: viewModel.titleText)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        titleTextField.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        contentView.addSubview(titleTextField)
        
        titleTextField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
}
