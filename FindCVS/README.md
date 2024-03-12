# 🏪 내 근처 편의점 찾기 앱

> - 사용자의 현재 위치를 기반으로 주변의 편의점들의 위치를 지도에서 핀으로 나타탬
> - 지도 아래에 편의점 목록을 확인할 수 있고 클릭 시 해당 편의점이 지도 중앙에 나타남
> - 주변에 편의점이 없거나 에러가 발생하면 alert으로 알려줌

![Simulator Screen Recording - iPhone 14 - 2024-03-12 at 00 05 06](https://github.com/mijisuh/fastcampus-ios/assets/57468832/e871a69e-f98c-40fe-bf4f-66ad6a6cff83)

## 개념 정리

<details>
<summary>CLLocationManager</summary>

## CLLocationManager

- 앱에 위치 기반의 기능을 구현할 수 있도록 함
- **앱에 대한 위치 관련 이벤트 전달을 시작하거나 중지하는데 사용하는 객체**
    - 앱에 위치 서비스를 추가하려면 `CLLocationManager`를 사용해서 Delegate를 구현하고 앱에 필요한 위치 정보에 액세스할 수 있는 권한을 요청해야 함
    - 앱 실행 시 해당 기기가 위치 서비스를 지원하는지 확인하고 원하는 위치 서비스를 구성하고 시작
    - 사용자의 위치를 수신하기 위해 권한을 요청하고 사용자가 이 요청을 승인하게 되면 앱은 요청하는 핵심 위치 서비스에 대한 즉, Core Location에 대한 위치 이벤트를 수신하게 됨
    - Delegate를 통해서 장치에서 위치 서비스를 사용할 수 없을 때 혹은 사용자가 권한을 부여하지 않았을 때에 대한 오류 처리도 함
    - 앱에 대한 승인 상태를 결정 → 사용자가 해당 앱에 위치 정보를 어떻게 주고 싶은지를 결정(앱을 사용할 때만, 이번 한번만, 항상)
- 주요 지원 기능
    - 사용자의 현재 위치에서 크거나 작은 변화를 추적 ex. 네비게이션
    - 나침반에서 방향 변경 추적
    - 사용자 위치 기반 이벤트 생성
    - 근거리 데이터 통신 기기(Bluetooth Beacon)와 통신
</details>

<details>
<summary>UnitTest, Nimble</summary>

## Unit Test

- 앱 하나를 통째로 테스트하는 것이 아닌 **소스코드의 특정 모듈이 의도한대로 잘 작동하는지 검증**하는 것
    - 원하는 값이 나오는지 검증
    - 연속되어야 하는 동작이 수행되는지 검증
    - ex) Input의 타입과 값이 예상대로 들어온다는 보장이 없는 경우
        
        <img width="855" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/9de6fd1d-fac9-4c89-983a-24c39fbcfdf2">
        
## XCTest

- Xcode 프로젝트에 대한 단위, 성능, UI 등의 테스트를 만들고 실행할 수 있게 하는 프레임워크
- 테스트 대상에서 테스트 케이스, 테스트 메서드를 추가해서 코드가 예상대로 잘 작동하는지 확인
- `XCTestCase` 상속
    - 테스트 범위, 내용에 대한 정의
    - 테스트를 시작하기 전 초기 상태를 준비하고 테스트가 완료된 후 정리까지 수행
    - `setUp()`: 테스트 케이스가 시작되기 전에 초기 상태를 사용자 정의할 수 있도록 기회 제공(목업 데이터 추가)
    - `tearDown()`:  테스트 케이스 종료 후에 정리를 할 수 있게 기회 제공
- 예제 코드
    
    ```swift
    class TableValidationTests: XCTestCase {
    
    	// 0개의 row와 column을 갖는 새 UITableView 객체 테스트
    	func testEmptyTableRowAndColumnCount() {
    		let table = Table() // 가정할 Table
    		XCTAssertEqual(table.rowCount, 0, "Row의 개수는 0이어야 한다.") // 가정이 false일 경우 에러 메시지
    		XCTAssertEqual(table.columnCount, 0, "Column의 개수는 0이어야 한다.")
    	}
    
    }
    ```
    

## Nimble

- 기본 프레임워크인 XCTest를 보다 편리하고 직관적으로 사용할 수 있게 하는 오픈 소스 프레임워크
- **읽기 쉬운 Test Assertion 표현**
    
    <img width="949" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3606b1b8-8dc2-45b2-ab5e-1defbecf7954">
    
- 간편한 비동기 테스트 작성
</details>

<details>
<summary>RxTest</summary>

## RxTest

- Observable의 테스트
    - Observable은 특정한 값이 아니라 시퀀스(이벤트의 흐름)
- **Observable에 가상의 시간 개념을 주입**
    - 언제, 무엇이 나왔는지 검증 가능
        
        ```swift
        // 가상의 시간 흐름 생성
        let scheduler = TestScheduler(initialClock: 0)
        
        // 원하는 시점에 Event가 발생하는 Observable 생성(구독의 여부와 관계없이 이벤트 발생)
        let observable = scheduler.createHotObservable([
        				.next(1, "A")
        				.next(2, "B")
        				.next(3, "C")
        		])
        
        // 원하는 시점에 Event가 발생하는 Observable 생성(구독이 시작되어야 정해진 순서대로 이벤트 발생)
        let observable = scheduler.createColdObservable([
        				.next(1, "A")
        				.next(2, "B")
        				.next(3, "C")
        		])
        
        // String을 관찰하는 Observer 생성
        let observer = scheduler.createObserver(String.self)
        
        observable
        		.subscribe(observer)
        		.disposed(by: disposeBag)
        
        // 가상의 시간이 모두 흐르도록
        scheduler.start()
        
        // Nimble의 문법을 활용한 Test Assertion
        expect(observer.events).to(
        		equal([
        				.next(1, "A")
        				.next(2, "B")
        				.next(3, "C")
        		])
        )
        ```
        
- **임의의 Observer를 통해 subscribe 여부 관계없이 검증 가능**
    - 가상의 시간이 다 흐를 때까지 관찰한 후에 타이밍과 이벤트를 반환할 수 있음
- Scheduler의 개념이 필요하고 원하는 타이밍에 원하는 값이 나오는 등 복잡한 검증이 필요한 경우 사용
</details>

<details>
<summary>RxBlocking</summary>

## RxBlocking

- Observable의 Event 방출을 검증
    
    ```swift
    // Observable -> BlockingObservable
    let observable = Observable.of("A, "B", "C").toBlocking()
    
    // Observable의 .next 이벤트를 Array로 전환
    // 해당 Observable이 완료될 때(onCompleted)까지 기다림
    let values = try! observable.toArray()
    
    // Nimble의 문법을 활용한 Test Assertion
    expect(values).to(equal(["A, "B", "C"]))
    ```
    
- 특정 시간동안 방출된 Observable의 Event 검증
    
    ```swift
    // Observable -> BlockingObservable
    let observable = Observable.of("A, "B", "C").toBlocking(timeout: 2)
    
    // Observable의 .next 이벤트를 Array로 전환
    // 해당 Observable이 완료될 때(onCompleted)까지 기다림
    let values = try! observable.toArray()
    
    // Nimble의 문법을 활용한 Test Assertion
    expect(values).to(equal(["A, "B", "C"]))
    ```
     - completed을 보장하지 않는 경우 → `BlockingObservable`을 생성할 때 `timeout` interval 설정
    
- Scheduler의 개념은 없고 단순히 Observable이 방출하는 값들을 배열로 전환해서 기대하는 값이 제대로 방출되는지만 검증하는 경우 사용
</details>


## 전체 화면 구성

<img width="683" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/99313242-a2c4-4ff4-b842-c3b3285e6286">

## 구현 내용
1. Kakao Map API 연결하기
    - [지도 SDK 다운로드](https://apis.map.kakao.com/ios/guide/)
    - Bundle ID 등록
        - info.plist로 등록한 키와 일치한 Bundle ID를 가진 프로젝트만 지도 SDK 사용 가능
    - info.plist에 네이티브 앱 키 추가
        - KAKAO_APP_KEY
    - 다운로드 받은 프레임워크 파일 Xcode 프로젝트에 추가
    - 브릿징 헤더 추가(Objective-C → Swift)
        - Header 파일 생성
        - Project → Target → All → Swift Compiler - General → Objective-C Bridging Header에 Header 파일의 full path 입력
    - 추가적인 라이브러리 파일 추가
        - Project → Target → Build Phases → Link Binary With Libraries
    - SDK가 ARC를 지원하지 않으므로 설정 필요
        - Project → Build Settings → Combined → Apple Clang - Language - Objective-C → Objective-C Automatic Reference Counting: No
    - SnapKit, RxSwift는 CocoaPods으로 설정(SPM은 에러)
2. Entity 만들기
    - API 콜로 받을 데이터
    - 테이블뷰에 뿌려줄 Cell 데이터
    - 커스텀 Error
3. MVVM 패턴으로 Model, ViewModel, View 구성하기
    - LocationInformation
        - ViewModel
            - 네트워크 통신으로 데이터 불러오기
            - 네트워크 통신에서 발생한 에러 메시지 전달
            - 지도 중심점 설정
            - 데이터의 존재 여부로 DetailListBackgroundViewModel의 Label 숨김 여부 설정
            - 지도에서 핀 클릭 시 리스트에 해당 편의점 표시
        - Model
            - API 콜로 데이터 받음
            - 데이터를 Cell 데이터로 변환
            - 데이터를 MTMapPoint로 변환
        - View
            - 리스트에 Cell 데이터 뿌려주기
            - 맵 뷰에 핀 뿌려주기
            - 맵의 가운데 위치로 이동하기
            - 에러 메시지 Alert
            - `CLLocationManagerDelegate`, `MTMapViewDelegate`에서 받은 값 ViewModel에 전달
    - DetailList
        - ViewModel
            - 에러가 나면 BackgroundView의 라벨을 보여줌
4. 데이터 연결하기
    - LocalAPI 구성
    - LocalNetwork로 API 콜 및 JSON 디코딩
5. Model 테스트하기
    - File → New → Target… → Unit Testing Bundle
    - 더미 데이터 생성
        - API 콜로 받을 데이터 형식 그대로 따름 → JSON
        - 전역 변수로 생성
        - 파일에서 불러와 Decoding
    - Stubber를 통해 가상의 더미 데이터를 실제 네트워크 상에서 응답받은 것 처럼 사용
        - 실제 API 콜 대신에 더미 데이터를 내뿜음
        - 테스트가 필요한 클래스를 상속 받고 메서드를 오버라이드
            
            ```swift
            import Foundation
            import RxSwift
            import Stubber
            
            @testable import FindCVS // 테스트 대상을 Wrapping
            
            class LocalNetworkStub: LocalNetwork {
                
                override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
                    return Stubber.invoke(getLocation, args: mapPoint) 
                }
                
            }
            ```
            
    - 테스트 내용 정의
        - `XCTestCase`를 상속 받음
        - Nimble 활용해서 Assert 문 작성
            
            ```swift
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
            ```
            
6. ViewModel 테스트하기
    - RxTest의 scheduler 사용해서 시간 별로 테스트
        - LocationInformationViewModel의 메서드를 참고해서 구현
            
            ```swift
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
            ```