//
//  Language.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import Foundation

enum Language: String, CaseIterable, Codable { // enum에서 Codable을 사용하는 경우 String을 rawValue로 사용할 수 있게 수정해야 함
    case ko
    case en
    case jp = "ja"
    case cn = "zh"
    
    var title: String { // 사용자에게 보여질 것
        switch self {
        case .ko: return NSLocalizedString("Korean", comment: "한국어")
        case .en: return NSLocalizedString("English", comment: "영어")
        case .jp: return NSLocalizedString("Japanese", comment: "일본어")
        case .cn: return NSLocalizedString("Chinese", comment: "중국어")
        }
    }
    
    var languageCode: String {
        self.rawValue
    }
}
