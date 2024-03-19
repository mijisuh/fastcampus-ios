//
//  MovieSearchRequestModel.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

struct MovieSearchRequestModel: Codable {
    let collection: String = "kmdb_new2"
    let serviceKey: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case serviceKey = "ServiceKey"
        case collection, title
    }
}
