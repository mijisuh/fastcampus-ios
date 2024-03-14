//
//  TranslationrManager.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import Foundation

struct TranslationManager {
    let translator = SwiftGoogleTranslate.shared
    
    var sourceLanguage: Language = .ko
    var targetLanguage: Language = .en
    
    func translate(
        from text: String,
        completionHandler: @escaping (String) -> Void
    ) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        translator.start(with: apiKey)
        
        translator.translate(text, targetLanguage.languageCode, sourceLanguage.languageCode) { text, error in
            guard let text = text, error == nil else { return }
            completionHandler(text)
        }
    }
}
