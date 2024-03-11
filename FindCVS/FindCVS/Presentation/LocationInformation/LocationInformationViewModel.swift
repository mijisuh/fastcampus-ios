//
//  LocationInformationViewModel.swift
//  FindCVS
//
//  Created by mijisuh on 2024/03/11.
//

import RxSwift
import RxCocoa

struct LocationInformationViewModel {
    
    let disposeBag = DisposeBag()
    
    // SubViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    // ViewModel -> View
    let setMapCenter: Signal<MTMapPoint> // 센터를 찾으라는 이벤트
    let errorMessage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelectedLocation: Signal<Int> // 지도에서 핀 클릭 시 리스트에 해당 편의점 표시(row)
    
    // View -> ViewModel
    // Delegate로 받은 값들 전달
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    private let documentData = PublishRelay<[KLDocument]>()
    
    init(model: LocationInformationModel = LocationInformationModel()) {
        // MARK: 네트워크 통신으로 데이터 불러오기
        let cvsLocationDataResult = mapCenterPoint // View에서 mapCenterPoint 받아올 때마다
            .flatMapLatest(model.getLocation) // API 통신
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap { data -> LocationData? in // nil 값 사라짐
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap { data -> String? in
                switch data {
                case let .success(data) where data.documents.isEmpty:
                    return """
                    500m 근처에 이용할 수 있는 편의점이 없어요.
                    지도 위치를 옮겨서 재검색해주세요.
                    """
                case let .failure(error):
                    return error.localizedDescription
                default: // 성공한 경우
                    return nil
                }
            }
        
        cvsLocationDataValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: disposeBag)
        
        // MARK: 지도 중심점 설정
        let selectedDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] } // 해당하는 row의 document 데이터를 뽑아냄
            .map(model.documentToMTMapPoint)
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation) // currentLocation을 한 번이라도 받은 이후에 버튼을 클릭했을 때
        let currentMapCenter = Observable
            .merge(
                currentLocation.take(1), // currentLocation를 최초로 1번 받는 경우
                moveToCurrentLocation, // 버튼 클릭 시
                selectedDetailListItem // 리스트 클릭 시
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = Observable
            .merge(
                cvsLocationDataErrorMessage,
                mapViewError.asObservable()
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        detailListCellData = documentData // API 통신
            .map(model.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map { !$0.isEmpty }
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag } // 고유 값
            .asSignal(onErrorJustReturn: 0)
    }
    
}
