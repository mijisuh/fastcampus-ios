//
//  LocationInformationModelTests.swift
//  FindCVSTests
//
//  Created by mijisuh on 2024/03/11.
//

import XCTest
import Nimble

@testable import FindCVS

final class LocationInformationModelTests: XCTestCase {
    
    let stubNetwork = LocalNetworkStub() // 실제 네트워크 통신을 하지 않고 가상의 네트워크 스텁을 이용
    
    var doc: [KLDocument]!
    var model: LocationInformationModel!
    
    override func setUp() {
        self.model = LocationInformationModel(localNetwork: stubNetwork)
        
        self.doc = cvsList
    }

    func testDocumentsToCellData() {
        let cellData = model.documentsToCellData(doc) // 실제 Model의 값
        let placeName = doc.map { $0.placeName } // Dummy 값
        let address0 = cellData[1].address // 실제 Model의 값
        let roadAddressName = doc[1].roadAddressName // Dummy 값
        
        expect(cellData.map { $0.placeName}).to(
            equal(placeName),
            description: "DetailListCellData와 placeName은 document의 placeName이다."
        )
        
        expect(address0).to(
            equal(roadAddressName),
            description: "KLDocument의 roadAddressName이 빈 값이 아닐 경우 roadAddress가 cellData에 전달된다."
        )
    }
    
}
