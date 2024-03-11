//
//  DetailListBackgroundViewModel.swift
//  FindCVS
//
//  Created by mijisuh on 2024/03/11.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    
    // ViewModel -> View
    let isStatusLabelHidden: Signal<Bool> // 데이터가 없을 경우 보여짐
    
    // 외부 -> ViewModel
    let shouldHideStatusLabel = PublishRelay<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true) // 에러가 나면 숨김
    }
    
}
