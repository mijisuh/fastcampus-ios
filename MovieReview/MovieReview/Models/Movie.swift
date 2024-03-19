//
//  Movie.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

struct Movie: Codable {
    let title: String
    private let posters: String
    private let actors: [String: [Actor]]
    private let directors: [String: [Director]]
    let repRatDate: String
    
    var isLiked: Bool = false // 파싱 에러를 발생시키므로 추가적인 처리 필요

    var imageURL: URL? { URL(string: posters.components(separatedBy: "|").first ?? "") }
    var actorNames: [String] { actors.first?.value.compactMap { $0.name } ?? [] }
    var directorNames: [String] { directors.first?.value.compactMap { $0.name } ?? [] }
    
    enum CodingKeys: String, CodingKey {
        case title, posters, actors, directors, repRatDate, isLiked // 서버에서 가져올 값들
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)

        // 값이 있으면 파싱
        title = try containter.decodeIfPresent(String.self, forKey: .title) ?? "-"
        posters = try containter.decodeIfPresent(String.self, forKey: .posters) ?? "-"
        actors = try containter.decodeIfPresent([String: [Actor]].self, forKey: .actors) ?? [:]
        directors = try containter.decodeIfPresent([String: [Director]].self, forKey: .directors) ?? [:]
        repRatDate = try containter.decodeIfPresent(String.self, forKey: .repRatDate) ?? "-"
        
        isLiked = try containter.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
    }
    
    init(
        title: String,
        posters: String,
        actors: [String: [Actor]],
        directors: [String: [Director]],
        repRatDate: String,
        isLiked: Bool = false
    ) {
        self.title = title
        self.posters = posters
        self.actors = actors
        self.directors = directors
        self.repRatDate = repRatDate
        self.isLiked = isLiked
    }
}

struct Director: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "directorNm"
    }
}

struct Actor: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "actorNm"
    }
}
