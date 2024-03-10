//
//  CategoryViewModel.swift
//  UsedGoodsUpload
//
//  Created by mijisuh on 2024/03/09.
//

import RxSwift
import RxCocoa

struct CategoryViewModel {
    
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let cellData: Driver<[Category]> // 카테고리 정보
    let pop: Signal<Void> // pop 이벤트
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    
    // View -> ParentsViewModel(MainViewController)
    let selectedCategory = PublishSubject<Category>()
    
    init() {
        let categories = [
            Category(id: 1, name: "디지털/가전"),
            Category(id: 2, name: "게임"),
            Category(id: 3, name: "스포츠/레저"),
            Category(id: 4, name: "유아/아동용품"),
            Category(id: 5, name: "여성패션/잡화"),
            Category(id: 6, name: "뷰티/미용"),
            Category(id: 7, name: "남성패션/잡화"),
            Category(id: 8, name: "생활/식품"),
            Category(id: 9, name: "가구"),
            Category(id: 10, name: "도서/티켓/취미"),
            Category(id: 11, name: "기타"),
        ]
        
        self.cellData = Driver.just(categories)
        
        self.itemSelected
            .map { categories[$0] } // 전달된 row에 해당하는 category가 무엇인지 변환
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        self.pop = itemSelected
            .map { _ in Void() } // 선택했는지 여부 확인
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
