//
//  LocalNetworkStub.swift
//  FindCVSTests
//
//  Created by mijisuh on 2024/03/11.
//

import Foundation
import RxSwift
import Stubber // 네트워크 변수에 의해 에러가 날 수 있으므로 가상의 더미 데이터로 실제 네트워크 상에서 응답받은 것처럼 사용

// 실제 API 콜 대신에 더미 데이터를 내뿜음
@testable import FindCVS // 테스트 대상을 Wrapping

class LocalNetworkStub: LocalNetwork {
    
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return Stubber.invoke(getLocation, args: mapPoint)
    }
    
}
