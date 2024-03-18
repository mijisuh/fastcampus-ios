//
//  NewsSearchManager.swift
//  KeywordNews
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation
import Alamofire

protocol NewsSearchManagerProtocol { // Test 작성을 용이하게 하기 위함
    func request(
        from keword: String,
        start: Int,
        display: Int,
        completionHandler: @escaping ([News]) -> Void
    )
}

struct NewsSearchManager: NewsSearchManagerProtocol {
    func request(
        from keword: String,
        start: Int,
        display: Int,
        completionHandler: @escaping ([News]) -> Void
    ) {
        guard let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String,
              let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String,
              let url = URL(string: "https://openapi.naver.com/v1/search/news.json")
        else { return }
        
        let parameter = NewsRequestModel(start: start, display: display, query: keword)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientId,
            "X-Naver-Client-Secret": clientSecret
        ]
        
        AF
            .request(url, method: .get, parameters: parameter, headers: headers)
            .responseDecodable(of: NewsResponseModel.self) { response in
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
