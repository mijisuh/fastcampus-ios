//
//  Diary.swift
//  Diary
//
//  Created by mijisuh on 2024/02/21.
//

import Foundation

struct Diary {
    var uuidString: String // 일기를 특정할 수 있는 고유값
    var title: String
    var contents: String
    var date: Date
    var isStar: Bool // 즐겨찾기 여부
}
