//
//  MovieSearchManager.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation
import Alamofire

protocol MovieSearchManagerProtocol {
    func request(from keyword: String, completionHandler: @escaping ([Movie]) -> Void)
}

struct MovieSearchManager: MovieSearchManagerProtocol {
    func request(from keyword: String, completionHandler: @escaping ([Movie]) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
              let url = URL(string: "http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp")
        else { return }
 
        let parameters = MovieSearchRequestModel(serviceKey: apiKey, title: keyword)

        AF
            .request(url, method: .get, parameters: parameters)
            .responseDecodable(of: MovieSearchResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result.movies)
                case .failure(let error):
                    print(error)
                }
            }
            .resume()
    }
}
