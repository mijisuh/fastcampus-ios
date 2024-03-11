//
//  Dummy.swift
//  FindCVSTests
//
//  Created by mijisuh on 2024/03/11.
//

import Foundation

@testable import FindCVS

var cvsList: [KLDocument] = Dummy().load("networkDummy.json")

class Dummy {
    
    func load<T: Decodable>(_ filename: String) -> T { // 전역 변수로 정의한 파일을 Decoding
        let data: Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: filename, withExtension: nil) else { fatalError("\(filename)을 main bundle에서 불러올 수 없습니다.") }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("\(filename)을 main bundle에서 불러올 수 없습니다. \(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("\(filename)을 \(T.self)로 파싱할 수 없습니다. \(error)")
        }
    }
    
}
