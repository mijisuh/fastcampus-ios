//
//  LocationInformationViewModelTests.swift
//  FindCVSTests
//
//  Created by mijisuh on 2024/03/11.
//

import XCTest
import RxSwift
import RxTest
import Nimble

@testable import FindCVS

final class LocationInformationViewModelTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    let networkStub = LocalNetworkStub()
    
    var model: LocationInformationModel!
    var viewModel: LocationInformationViewModel!
    
    var doc: [KLDocument]!
    
    override func setUp() {
        self.model = LocationInformationModel(localNetwork: networkStub)
        self.viewModel = LocationInformationViewModel(model: model)
        self.doc = cvsList
    }
    
    func testSetMapCenter() {
        let scheduler = TestScheduler(initialClock: 0)
        
        // 더미 데이터의 이벤트
        let dummyDataEvent = scheduler.createHotObservable([
            .next(0, cvsList)
        ])
        
        let documentData = PublishSubject<[KLDocument]>()
        dummyDataEvent
            .subscribe(documentData)
            .disposed(by: disposeBag)
        
        // DetailList 아이템(셀) 탭 이벤트
        let itemSelectedEvent = scheduler.createHotObservable([
            .next(1, 0) // 1초 뒤 0번째 아이템 클릭
        ])
        
        let itemSelected = PublishSubject<Int>()
        itemSelectedEvent
            .subscribe(itemSelected)
            .disposed(by: disposeBag)
        
        let selectedItemMapPoint = itemSelected
            .withLatestFrom(documentData) { $1[$0]}
            .map(model.documentToMTMapPoint)
        
        // 최초 현재 위치 이벤트
        let initialMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(37.394225), longitude: Double(127.110341)))!
        
        let currentLocaionEvent = scheduler.createHotObservable([
            .next(0, initialMapPoint)
        ])
        
        let initialCurrentLocation = PublishSubject<MTMapPoint>()
        
        currentLocaionEvent
            .subscribe(initialCurrentLocation)
            .disposed(by: disposeBag)
        
        // 현재 위치 버튼 탭 이벤트
        let currentLocationButtonTapEvent = scheduler.createHotObservable([
            .next(2, Void()),
            .next(3, Void())
        ])
        
        let currentLocationButtonTapped = PublishSubject<Void>()
        currentLocationButtonTapEvent
            .subscribe(currentLocationButtonTapped)
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(initialCurrentLocation)
        
        // Merge
        let currentMapCenter = Observable
            .merge(
                selectedItemMapPoint,
                initialCurrentLocation.take(1),
                moveToCurrentLocation
            )
        
        let currentMapCenterObserver = scheduler.createObserver(Double.self)
        
        currentMapCenter
            .map { $0.mapPointGeo().latitude }
            .subscribe(currentMapCenterObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let secondMapPoint = model.documentToMTMapPoint(doc[0])
        
        expect(currentMapCenterObserver.events).to(
            equal([
                .next(0, initialMapPoint.mapPointGeo().latitude), // 정확한 비교를 위해 Double 값 비교
                .next(1, secondMapPoint.mapPointGeo().latitude),
                .next(2, initialMapPoint.mapPointGeo().latitude),
                .next(3, initialMapPoint.mapPointGeo().latitude)
            ])
        )
    }
    
}
