//
//  MockNewsSearchManager.swift
//  KeywordNewsTests
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

@testable import KeywordNews

final class MockNewsSearchManager: NewsSearchManagerProtocol {
    var error: Error?
    var isCalledRequest = false
    
    func request(
        from keword: String,
        start: Int,
        display: Int,
        completionHandler: @escaping ([KeywordNews.News]) -> Void
    ) {
        isCalledRequest = true
        
        if error == nil {
            completionHandler([])
        }
    }
}
