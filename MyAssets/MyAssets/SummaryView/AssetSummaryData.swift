//
//  AssetSummaryData.swift
//  MyAssets
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

class AssetSummaryData: ObservableObject {
    
    @Published var assets: [Asset] = load("assets.json") // 어떤 데이터를 내보낼지 표현
    
}

func load<T: Decodable>(_ filename: String) -> T { // json 파일을 입력 받으면 원하는 형태로 디코딩해주는 함수
    let data: Data
    
    guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError(filename + "을 찾을 수 없습니다.")
    }
    
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError(filename + "을 찾을 수 없습니다.")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError(filename + "을 \(T.self)로 파싱할 수 없습니다.")
    }
}
