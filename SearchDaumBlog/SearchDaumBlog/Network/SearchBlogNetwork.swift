//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    
    case invalidURL
    case invalidJSON
    case networkError
    
}

class SearchBlogNetwork {
    
    private let session: URLSession
    let api = SearchBlogAPI()
    
    // Use Plist for get API_KEY
    private var apiKey: String {
        get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Info.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
            }
            return value
        }
    }
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // API 호출 + JSON 파싱
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>> { // Result는 Swift에서 기본적으로 제공하는 enum으로 성공/실패 두가지 경우를 받음
        guard let url = api.searchBlog(query: query).url else { return .just(.failure(.invalidURL)) }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 6590cdd6950698586ca872a1622a9c77", forHTTPHeaderField: "Authorization") // 키
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
    
}
