//
//  MainViewModel.swift
//  UsedGoodsUpload
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

struct MainViewModel {
    
    let titleTextFieldViewModel = TitleTextFieldCellViewModel()
    let priceTextFieldViewModel = PriceTextFieldCellViewModel()
    let detailWriteFormViewModel = DetailWriteFormCellViewModel()
    
    // ViewModel -> View
    let cellData: Driver<[String]>
    let present: Signal<Alert>
    let push: Driver<CategoryViewModel>
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    let submitButtonTapped = PublishRelay<Void>()
    
    init(model: MainModel = MainModel()) {
        let title = Observable.just("글 제목") // placeHolder로 표현
        
        let categoryViewModel = CategoryViewModel()
        let category = categoryViewModel
            .selectedCategory
            .map { $0.name }
            .startWith("카테고리 선택")
        
        let price = Observable.just("￦ 가격 (Optional)")
        let detail = Observable.just("내용을 입력하세요.")
        
        cellData = Observable
            .combineLatest(
                title,
                category,
                price,
                detail
            ) { [$0, $1, $2, $3] } // 배열로 묶음
            .asDriver(onErrorJustReturn: [])
        
        // presentAlert를 하는 시점 지정
        // 각 항목 입력 여부에 따라서 alert에 보여져야 하는 내용이 달라짐
        let titleMessage = titleTextFieldViewModel
            .titleText
            .map { $0?.isEmpty ?? true }
            .startWith(true)
            .map { $0 ? ["~ 글 제목을 입력해주세요."] : [] }
        
        let categoryMessage = categoryViewModel
            .selectedCategory
            .map { _ in false } // 선택된 카테고리가 있으면 false
            .startWith(true)
            .map { $0 ? ["~ 카테고리를 선택해주세요."] : [] }
        
        let detailMessage = detailWriteFormViewModel
            .contentValue
            .map { $0?.isEmpty ?? true }
            .startWith(true)
            .map { $0 ? ["~ 내용을 입력해주세요."] : [] }
        
        let detailMessage2 = detailWriteFormViewModel
            .textColor
            .map { $0 == UIColor.secondaryLabel }
            .startWith(true)
            .map { $0 ? ["~ 내용을 입력해주세요."] : [] }
        
        let errorMessage = Observable
            .combineLatest(
                titleMessage,
                categoryMessage,
                detailMessage,
                detailMessage2
            ) { $0 + $1 + $2 + $3 }
        
        present = submitButtonTapped // 제출 버튼을 탭하는 것이 트리거
            .withLatestFrom(errorMessage)
            .map { errorMessage -> (title: String, message: String?) in
                model.setAlert(errorMessage: errorMessage)
            }
            .asSignal(onErrorSignalWith: .empty())
        
        push = itemSelected
            .compactMap({ row -> CategoryViewModel? in
                guard case 1 = row else { return nil } // 두번째 셀이라면
                return categoryViewModel
            })
            .asDriver(onErrorDriveWith: .empty())
    }
    
}
