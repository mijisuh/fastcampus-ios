//
//  MovieSearchResponseModel.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

struct MovieSearchResponseModel: Decodable {
    private let data: [Result]
    var movies: [Movie] { data.first?.result ?? [] }

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct Result: Decodable {
    var result: [Movie] = []

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}
