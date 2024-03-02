//
//  Beer.swift
//  Brewery
//
//  Created by mijisuh on 2024/03/02.
//
  
import Foundation

struct Beer: Decodable {
    
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
    var tagLine: String {
        let tags = taglineString?.components(separatedBy: ". ")
        let hashTags = tags?.map {
            "#" + $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: " #")
        }
        return hashTags?.joined(separator: " ") ?? "" // #tag #good #hello
    }
    
    // 프로그램 안에서 쓸 키 값과 서버에서 받을 키 값이 다를 경우
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case taglineString = "tagline"
        case imageURL = "image_url"
        case brewersTips = "brewers_tips"
        case foodPairing = "food_pairing"
    }
    
}
