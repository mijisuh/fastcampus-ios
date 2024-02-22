//
//  DiaryCell.swift
//  Diary
//
//  Created by mijisuh on 2024/02/21.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    required init?(coder: NSCoder) { // UIView가 xib나 스토리보드에서 생성이 될 때 이 생성자를 통해 객체 생성
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0 // 셀의 루트 뷰 접근
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 210/255, alpha: 1).cgColor
    }
    
}
