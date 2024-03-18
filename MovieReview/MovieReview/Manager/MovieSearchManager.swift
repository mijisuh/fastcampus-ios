//
//  MovieSearchManager.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation
import Alamofire

struct MovieSearchManager {
    func request(from keyword: String) {
        guard let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID"),
              let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIEND_SECRET"),
              let url = URL(string: "https://openapi.naver.com/v1/search/book.json")
        else { return }
    }
}
