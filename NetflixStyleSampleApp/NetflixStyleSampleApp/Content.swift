//
//  Content.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/02/29.
//

import UIKit

struct Content: Decodable {
    let sectionType: SectionType // 몇몇 케이스로 정해져 있음 -> enum
    let sectionName: String
    let contentItem: [Item]
 
    enum SectionType: String, Decodable {
        case basic
        case main
        case large
        case rank
    }
}

struct Item: Decodable {
    let description: String
    let imageName: String // 파일명과 일치 -> UIImage로 바로 만들 수 있음
    
    var image: UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}
