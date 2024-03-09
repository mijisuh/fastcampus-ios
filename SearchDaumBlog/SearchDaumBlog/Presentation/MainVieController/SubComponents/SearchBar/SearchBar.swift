//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchBar: UISearchBar {
    
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    // searchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>() // onNext 이벤트만 받음
    
    // SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        // 1. searchbar button tapped(키보드 엔터)
        // 2. button tapped
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped) // 두 이벤트가 어떤 순서든 이벤트가 발생할 때마다 searchButtonTapped에 이벤트 방출
            .disposed(by: disposeBag)
        
        // 탭 이벤트 발생 시 키보드 내려감
        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        // 입력된 텍스트를 외부로 내보내기
        shouldLoadResult = searchButtonTapped // searchButtonTapped가 트리거 역할
            .withLatestFrom(self.rx.text) { $1 ?? "" } // 가장 최신의 text을 전달(없으면 "")
            .filter { !$0.isEmpty }
            .distinctUntilChanged() // 동일한 조건을 계속해서 검색해서 중복을 없애고 불필요한 네트워크가 발생하지 않도록 함
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
}

extension Reactive where Base: SearchBar {
    
    var endEditing: Binder<Void> { // base는 searchBar
        return Binder(base) { base, _ in
            base.endEditing(true) // 키보드가 내려갈 수 있게 함
        }
    }
    
}
