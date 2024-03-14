//
//  LanguageType.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit

enum LanguageType {
    case source
    case target
    
    var color: UIColor { // associate value
        switch self {
        case .source: return .label
        case .target: return .mainTintColor
        }
    }
}
