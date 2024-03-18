//
//  Movie.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

struct Movie: Decodable {
    let title: String
    private let image: String
    let userRating: String
    let actor: String
    let director: String
    let pubDate: String
    
    var imageURL: URL? { URL(string: image) }
}
