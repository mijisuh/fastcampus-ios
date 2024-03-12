//
//  CenterNetwork.swift
//  FindCoronaCenter
//
//  Created by mijisuh on 2024/03/12.
//

import Foundation
import Combine

class CenterNetwork {
    
    private let session: URLSession
    
    let api = CenterAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCenterList() -> AnyPublisher<[Center], URLError> { // Error를 기본적으로 갖게 함
        guard let url = api.getCenterListComponents().url,
              let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Infuser \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.unknown) }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    return data
                case 400..<500:
                    throw URLError(.clientCertificateRejected)
                case 500..<599:
                    throw URLError(.badServerResponse)
                default:
                    throw URLError(.unknown)
                }
            }
            .decode(type: CenterAPIResponse.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError { $0 as! URLError } // 에러가 나타났을 경우
            .eraseToAnyPublisher()
    }
    
}
