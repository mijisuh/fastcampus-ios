//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation
import RxSwift
import RxCocoa

struct BlogListViewModel {
    
    let filterViewModel = FilterViewModel() // BlogListView가 FilterView를 헤더로 가지고 있기 때문에
    
    // MainViewController -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
    
}
