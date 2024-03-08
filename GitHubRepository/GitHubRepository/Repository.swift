//
//  Repository.swift
//  GitHubRepository
//
//  Created by mijisuh on 2024/03/08.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let starGazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case starGazersCount = "stargazers_count"
    }
    
}
