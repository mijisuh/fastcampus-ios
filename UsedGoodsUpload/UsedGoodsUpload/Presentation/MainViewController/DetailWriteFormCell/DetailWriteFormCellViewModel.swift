//
//  DetailWriteFormCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit
import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel {
    
    // View -> ViewModel
    let contentValue = PublishRelay<String?>()
    let textColor = PublishRelay<UIColor?>()
    
}
