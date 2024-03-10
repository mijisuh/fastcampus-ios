//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation
import RxSwift
import RxCocoa

struct FilterViewModel {
    
    // FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
    
}
