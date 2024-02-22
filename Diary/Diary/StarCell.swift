//
//  StarCell.swift
//  Diary
//
//  Created by mijisuh on 2024/02/21.
//

import UIKit

class StarCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 210/255, alpha: 1).cgColor
    }
    
}
