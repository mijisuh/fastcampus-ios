//
//  DKBlog.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import Foundation

struct DKBlog: Decodable {
    
    let documents: [DKDocument]
    
}

struct DKDocument: Decodable {
    
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try? values.decode(String?.self, forKey: .title)?
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: nil)
        self.name = try? values.decode(String?.self, forKey: .name)
        self.thumbnail = try? values.decode(String?.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime) // JSON에 Date라는 타입이 없기 때문에 이해 못함 -> 커스텀한 파싱 함수 필요
    }
    
}

extension Date {
    
    // CodingKey -> Date
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString)
        else { return nil }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // API마다 포맷이 다르므로 문서 확인 필요
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
}
