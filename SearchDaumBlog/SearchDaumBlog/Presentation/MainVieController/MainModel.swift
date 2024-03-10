//
//  MainModel.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation
import RxSwift
import RxCocoa

struct MainModel {
    
    // 네트워크 로직
    let network = SearchBlogNetwork()
    
    func searchBlog(_ query: String) -> Single<Result<DKBlog, SearchNetworkError>> {
        return network.searchBlog(query: query)
    }
    
    func getBlogValue(_ result: Result<DKBlog, SearchNetworkError>) -> DKBlog? {
        guard case .success(let value) = result else { return nil }
        return value
    }
    
    func getBlogError(_ result: Result<DKBlog, SearchNetworkError>) -> String? {
        guard case .failure(let error) = result else { return nil }
        return error.localizedDescription
    }
    
    func getBlogListCellData(_ value: DKBlog) -> [BlogListCellData] {
        return value.documents
            .map { doc in
                let thumnailURL = URL(string: doc.thumbnail ?? "") // String -> URL
                return BlogListCellData(thumbnailURL: thumnailURL, name: doc.name, title: doc.title, datetime: doc.datetime)
            }
    }
    
    func sort(_ type: MainViewController.AlertAction, of data: [BlogListCellData]) -> [BlogListCellData] {
        switch type {
        case .title: return data.sorted { $0.title ?? "" < $1.title ?? "" }
        case .datetime: return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() } // 최신 날짜 부터
        default: return data
        }
    }
    
}
