//
//  LocalNetwork.swift
//  FindCVS
//
//  Created by mijisuh on 2024/03/11.
//

import RxSwift

class LocalNetwork {
    
    private let session: URLSession
    let api = LocalAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> { // 성공 or 실패이기 때문에 Single
        guard let url = api.getLocation(by: mapPoint).url else { return .just(.failure(URLError(.badURL))) }
       
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 0199711765cdba7404efba816828be38", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData)
                } catch {
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { _ in .just(Result.failure(URLError(.cannotLoadFromNetwork))) }
            .asSingle()
    }
}
