//
//  LocationInformationModel.swift
//  FindCVS
//
//  Created by mijisuh on 2024/03/11.
//

import Foundation
import RxSwift

struct LocationInformationModel {
    
    var localNetwork: LocalNetwork
    
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return localNetwork.getLocation(by: mapPoint)
    }
    
    func documentsToCellData(_ data: [KLDocument]) -> [DetailListCellData] {
        return data
            .map {
                let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
                let point = documentToMTMapPoint($0)
                return DetailListCellData(
                    placeName: $0.placeName,
                    address: address,
                    distance: $0.distance,
                    point: point
                )
            }
    }
    
    func documentToMTMapPoint(_ document: KLDocument) -> MTMapPoint {
        let longitude = Double(document.x) ?? .zero
        let latitude = Double(document.y) ?? .zero
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
}
