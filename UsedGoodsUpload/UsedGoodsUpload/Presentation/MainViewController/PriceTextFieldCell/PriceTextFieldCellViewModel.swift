//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by mijisuh on 2024/03/09.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    
    // ViewModel -> View
    let showFreeShareButton: Signal<Bool>
    let resetPrice: Signal<Void>
    
    // View -> ViewModel
    let priceValue = PublishRelay<String?>() // UI 이벤트이므로 PublishRelay
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init() {
        showFreeShareButton = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0" }, // 입력한 가격이 없거나 0원인 경우
                freeShareButtonTapped.map { _ in false } // 무료나눔 버튼을 눌렀으면 숨겨라
            )
            .asSignal(onErrorJustReturn: false)
        
        resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
