//
//  Alert.swift
//  Drink
//
//  Created by mijisuh on 2024/02/28.
//

import Foundation

struct Alert: Codable {
    
    var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool
    
    var time: String { // date 값을 바로 라벨에 뿌려줄 수 있도록 String으로 변환
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    
    var meridiem: String {
        let meridiemFormatter = DateFormatter()
        meridiemFormatter.dateFormat = "a" // 오전/오후
        meridiemFormatter.locale = Locale(identifier: "ko")
        return meridiemFormatter.string(from: date)
    }
    
}
