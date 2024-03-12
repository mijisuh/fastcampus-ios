//
//  MapView.swift
//  FindCoronaCenter
//
//  Created by mijisuh on 2024/03/12.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable { // 핀 표시 정보
    
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    
}

struct MapView: View {
    
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion() // 현재 View 내에서만 변화
    @State private var annotationItems = [AnnotationItem]()
    
    init(coordinate: CLLocationCoordinate2D) { // onAppear에서 수행 시 좌표값이 초기화되기 전에 Map이 먼저 그려짐
        self.coordinate = coordinate
        _region = State(
            initialValue: MKCoordinateRegion(
                center: coordinate, // 맵의 가운데 좌표 설정
                span: MKCoordinateSpan( // 맵의 멀거나 가까운 정도(1에 가까울수록 넓은 범위의 맵을 보여줌)
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        )
        _annotationItems = State(
            initialValue: [AnnotationItem(coordinate: coordinate)]
        )
    }
    
    var body: some View {
        Map(
            coordinateRegion: $region, // $region: 계속 주시하겠다는 것을 표현
            annotationItems: annotationItems
        ) {
            MapMarker(coordinate: $0.coordinate)
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    private func setAnnotationItems(_ coordinate: CLLocationCoordinate2D) {
        annotationItems = [AnnotationItem(coordinate: coordinate)]
        print(coordinate)
    }
    
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, facilityName: "실내방상장 앞", address: "경기도 뫄뫄시 뫄뫄구", lat: "37.404476", lng: "126.9491998", centerType: .central, phoneNumber: "010-0000-0000")
        MapView(
            coordinate: CLLocationCoordinate2D(
                latitude: CLLocationDegrees(center0.lat) ?? .zero,
                longitude: CLLocationDegrees(center0.lng) ?? .zero
            )
        )
    }
    
}
