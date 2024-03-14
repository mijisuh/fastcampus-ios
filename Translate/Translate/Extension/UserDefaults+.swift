//
//  UserDefaults+.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import Foundation

extension UserDefaults {
    // Key 값을 enum으로 사용하면 매번 UserDefaults.standard.data(forKey: "")에서 String 값으로 수동으로 입력해줘야 하기 때문에 입력 오류가 있을 수도 있음
    enum Key: String {
        case bookmarks
    }
    
    var bookmarks: [Bookmark] { // computed property
        get { // UserDefaults에서 데이터 가져와서 디코딩
            guard let data = UserDefaults.standard.data(forKey: Key.bookmarks.rawValue) else { return [] }
            
            return (try? PropertyListDecoder().decode([Bookmark].self, from: data)) ?? []
        }
        
        set { // UserDefaults에서 데이터 저장
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Key.bookmarks.rawValue)
        }
    }
}
