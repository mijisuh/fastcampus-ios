//
//  Book.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import Foundation

struct Book: Decodable {
    let title: String // 필수이기 때문에 optional 아님
    private let image: String?
    
    var imageURL: URL? { // Kingfisher에서 사용하기 쉽도록
        URL(string: image ?? "")
    }
    
    init(title: String, image: String?) {
        self.title = title
        self.image = image
    }
}
