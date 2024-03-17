//
//  BookSearchManager.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import Foundation
import Alamofire

struct BookSearchManager {
    func request(from keyword: String, completionHandler: @escaping ([Book]) -> Void) {
        // Request URL 구성
        guard let url = URL(string: "https://openapi.naver.com/v1/search/book.json"),
              let clientId = Bundle.main.object(forInfoDictionaryKey:"CLIENT_ID") as? String,
              let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String
        else { return }
        
        let parameters = BookSearchRequestModel(query: keyword)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientId,
            "X-Naver-Client-Secret": clientSecret
        ]
        
        // Request, Decoding
        AF
            .request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: BookSearchResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result.items)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
}
