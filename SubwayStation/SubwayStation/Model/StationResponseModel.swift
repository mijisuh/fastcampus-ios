//
//  StationResponseModel.swift
//  SubwayStation
//
//  Created by mijisuh on 2024/03/05.
//

import Foundation

struct StationResponseModel: Decodable {
    
    var stations: [Station] { searchInfo.row } // 외부에서 사용하기 쉽도록 정의 or StationResponseModel().searchInfo.row
    
    private let searchInfo: SearchInfoBySubwayNameServiceModel
    
    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }
    
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station] = []
    }
    
}

struct Station: Decodable {
    
    let stationName: String
    let lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
    
}
