//
//  LocationInformationViewController.swift
//  FindCVS
//
//  Created by mijisuh on 2024/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreLocation

final class LocationInformationViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    
    let mapView = MTMapView()
    let currentLocationButton = UIButton()
    let detailList = UITableView()
    let detailListBackgroundView = DetailListBackgroundView()
    let viewModel = LocationInformationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    func bind(_ viewModel: LocationInformationViewModel) {
        detailListBackgroundView.bind(viewModel.detailListBackgroundViewModel)
        
        viewModel.setMapCenter // Signal로 받음
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        // 리스트에 뿌려주기
        viewModel.detailListCellData
            .drive(detailList.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "DetailListCell", for: IndexPath(row: row, section: 0)) as! DetailListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        // 맵 뷰에 핀 뿌려주기
        viewModel.detailListCellData
            .map { $0.compactMap { $0.point } }
            .drive(self.rx.addPOIItems)
            .disposed(by: disposeBag)
        
        viewModel.scrollToSelectedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        detailList.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
            
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "내 주변 편의점 찾기"
        view.backgroundColor = .white
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving

        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
        
        detailList.register(DetailListCell.self, forCellReuseIdentifier: "DetailListCell")
        detailList.separatorStyle = .none
        detailList.backgroundView = detailListBackgroundView
    }
    
    private func layout() {
        [mapView, currentLocationButton, detailList].forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide) // 네비게이션 하단에 위치
            $0.bottom.equalTo(view.snp.centerY).offset(100) // 가운데에서 조금 떨어지게
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
    
}

extension LocationInformationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse, .authorized: return
        default: // .restricted, .denied
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDenied.errorDescription)
            return
        }
    }
    
}

extension LocationInformationViewController: MTMapViewDelegate {
    
    // 현재 위치를 계속 업데이트
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG // 시뮬레이터 사용 시
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
         viewModel.currentLocation.accept(location)
        #endif
    }
    
    // 맵의 이동(드래그)이 끝난 경우
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
         viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    // 핀 표시된 아이템을 탭한 경우
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
         viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    // 현재 위치를 불러오지 못했을 경우
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
         viewModel.mapViewError.accept(error.localizedDescription)
    }
    
}

extension Reactive where Base: MTMapView {
    
    var setMapCenterPoint: Binder<MTMapPoint> { // MTMapPoint을 받음
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
    
}

extension Reactive where Base: LocationInformationViewController {
    
    var presentAlert: Binder<String> { // String을 받음
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "문제가 발생했어요!", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alertController.addAction(action)
            base.present(alertController, animated: true)
        }
    }
    
    var showSelectedLocation: Binder<Int> { // Int를 받음
        return Binder(base) { base, row in
            let indexPath = IndexPath(row: row, section: 0)
            base.detailList.selectRow(at: indexPath, animated: true, scrollPosition: .top) // UITableView에서 해당 IndexPath가 가장 위에 뜨도록 자동적으로 이동
        }
    }
    
    var addPOIItems: Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            let items = points
                .enumerated()
                .map { offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    mapPOIItem.mapPoint = point
                    mapPOIItem.markerType = .redPin
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset // 고유값
                    return mapPOIItem
                }
            
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
    
}
