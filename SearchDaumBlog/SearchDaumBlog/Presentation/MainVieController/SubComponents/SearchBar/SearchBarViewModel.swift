//
//  SearchBarViewModel.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchBarViewModel {
    
    let quertText = PublishRelay<String?>()
    
    // searchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>() // onNext 이벤트만 받음
    
    // SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    init() {
        // 입력된 텍스트를 외부로 내보내기
        shouldLoadResult = searchButtonTapped // searchButtonTapped가 트리거 역할
            .withLatestFrom(quertText) { $1 ?? "" } // 가장 최신의 text을 전달(없으면 "")
            .filter { !$0.isEmpty }
            .distinctUntilChanged() // 동일한 조건을 계속해서 검색해서 중복을 없애고 불필요한 네트워크가 발생하지 않도록 함
    }
    
}
