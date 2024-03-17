//
//  BookSearchRequestModel.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import Foundation

struct BookSearchRequestModel: Codable {
    // ///: 자동완성에서 설명으로 뜸
    /// 검색할 책 키워드
    let query: String
}
