//
//  BookSearchResponseModel.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import Foundation

struct BookSearchResponseModel: Decodable {
    var items: [Book] = []
}
