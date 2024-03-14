//
//  Bookmark.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import Foundation

struct Bookmark: Codable {
    let sourceLanguage: Language
    let translatedLanguage: Language
    
    let sourceText: String
    let translatedText: String
}
