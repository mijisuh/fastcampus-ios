# 🏥 코로나19 예방접종 센터 조회 앱

> - 각 지자체별로 몇 개의 예방 접종 센터가 있는지 그리드 형태로 확인 가능
> - 각 지자체의 예방 접종 센터에 대한 정보를 리스트 형태로 확인 가능
> - 특정 예방 접종 센터에 대한 위치를 지도로 확인 가능

![Simulator Screen Recording - iPhone 14 - 2024-03-12 at 20 14 55](https://github.com/mijisuh/fastcampus-ios/assets/57468832/8457a07b-553a-4bc9-9259-1386fa7891d3)

## 개념 정리

<details>
<summary>Combine</summary>

## Combine

> A unified declarative API for processing values over time.
> 

> **Customize handling(커스터마이징)**
of **asynchronous events (비동기 이벤트 처리를)**
by **combining event-processing operators(이벤트 처리 연산자를 결합해서)**
> 

> Combine declares
publishers **to expose values that can change over time**, and
subcribers **to receive those values from the publisher**
> 

> By adopting Combine, you’ll **make your code easier to read and maintain**,
by **centralizing** your event-processing code
and **eliminating** troublesome techniques like **nested closures and convention-based callbacks**.
> 
- 기존 써드파티 프레임워크인 RxSwift를 **애플의 자체 프레임워크인 Combine으로 전환**해서 사용할 수 있음
- **SwiftUI와 함께 사용할 때 시너지가 좋음**
- Combine을 만든 이유?
    - Cocoa SDK 내에는 수많은 비동기적인 인터페이스가 있음(closure나 completion handler를 갖는 API)
        - IBTarget/IBAction
        - Notification Center
        - URLSession
        - KVO
        - Ad-hoc callbacks
    - 이들의 사용성을 높이기 위해 모두 새로운 기능을 대체하기보다 공통점을 관통하는 개념을 만드는게 효율적
    - **시간이 지남에 따라 발생하는 값을 처리하기 위한 통합된 선언적 API**
- Combine의 핵심 요소
    - **Publishers**
        - 어떤한 값을 방출
    - **Subscribers**
        - 값 방출을 관찰하고 있다가 수신
    - **Operators**
        - 둘 사이에서 여러가지 액션 수행
- Combine vs RxSwift
    
    <img width="991" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/5c08598e-b32e-4573-a122-f282bcafddd8">
    
    <img width="991" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e73f0d6a-3528-4de1-a5d5-07e79f0eec71">
    
    <img width="806" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4718ee60-1dee-43c4-869f-b820e3cf7b5d">
    
    <img width="806" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/323ac39e-73db-4b6a-85da-1f99215da095">
    
    - 외부 라이브러리를 사용하지 않기 때문에 앱 용량 차이가 많이 남
    
    <img width="806" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/0eafbf29-b1bc-4b44-ac8f-7fab941d35d1">
    
    - 동일한 연산을 했을 때 Combine의 alloc 수가 RxSwift의 1/4
</details>

<details>
<summary>Combine과 RxSwift 비교하기</summary>

## Publisher vs Observable

| Combine | RxSwift |
| --- | --- |
| AnyPublisher | Observable |
| `Publisher` 라는 protocol을 따르는 struct | class |
| 값 타입 | 참조 타입 |
| `associatetype Output` (Data 타입)<br>`associatetype Failure: Error` (Error 타입) | `class Observable<Element>` (Data 타입)<br>(Result 타입을 주입하면 Publisher와 비슷하게 구현 가능) |
| → `AnyPublisher<String, Error>`<br>→ `AnyPublisher<String, Never>` | → `Observable<Result<String, Error>>`<br>→ `Observable<String>` |

## Operators, RxSwift Only

- 대부분의 operator들이 공통되어 있음
    - RxSwift Only
        
        <img width="792" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/584a87d5-a0ac-4512-8433-4c1a1349d1fe">
        
    - Combine Only
        
        <img width="792" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/a1839f3b-df5a-4078-93d9-40266448274e">
        
        - try~: 에러를 보다 쉽게 핸들링할 수 있게 도와주는 operator

- Combining Operator
    - **묶을 수 있는 시퀀스의 개수에 따라서** 다른 이름을 가짐
    - RxSwift의 merge
        - Merge, Merge3, Merge4, Merge5, Merge6, Merge7, Merge8, MergeMany
    - RxSwift의 combineLatest
        - CombineLatest, CombineLatest3, CombineLatest4
    - RxSwift의 zip
        - Zip, Zip3, Zip4

## Subject

| Combine | RxSwift |
| --- | --- |
| Publisher + Subscriber | Observable + Observer |
| PassthroughSubject | PublishSubject |
| X | ReplaySubject |
| CurrentValueSubject | BehaviorSubject |

- PassthroughSubject
    - PublishSubject와 마찬가지로 초기값을 가지지 않음
        
        ```swift
        class PassthroughSubject<Output, Failure> {
        	public init()
        }
        ```
        
        ```swift
        class PublishSubject<Element> {
        	override init() { }
        }
        ```
        
- CurrentValueSubject
    - BehaviorSubject와 마찬가지로 초기 값을 가짐
        
        ```swift
        class CurrentValueSubject<Output, Failure> {
        	public init(_ value: Output)
        }
        ```
        
        ```swift
        class BehaviorSubject<Element> {
        	init(value: Element) { }
        }
        ```
        

## Cancellable vs Disposable

- Combine은 DisposeBag이 없어서 비슷하게 만들어주려면 Set 활용
    
    ```swift
    let cancellables = Set<Cancellable>() // let disposeBag = DisposeBag()
    
    Just(1)
    	.sink {
    		printt($0)
    	}
    	.store(in: &cancellables) // .disposed(by: disposeBag)
    ```
    

## Thread Handling

- RxSwift에서 observeOn과 subscribeOn이 동작하는 방식을 표현
    
    <img width="792" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ac8dbdc9-2c5c-456d-95f0-9a8d1d4438ad">
    
    - observeOn은 해당 코드 다음부터(아래 시퀀스)부터 작동
    - subscribeOn은 위치에 구애받지 않고(업 스트림, 다운 스트림) 전체적인 Observable의 쓰레드를 변화시킴
- **Combine에서의 subscribeOn은 업 스트림에서만 작동**
    
    ```swift
    Just(1)
    	.subcribe(on: DispatchQueue.main) // map 아래에 위치하면 동작 X
    	.map {
    		implements()
    	}
    	.sink { ... }
    ```
</details>

## 전체 화면 구성

<img width="947" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/1e18e3f2-9d35-4aef-985e-73cd835790e4">

## 구현 내용
1. 공공 API 연결하기
    - [공공 데이터 포털](https://www.data.go.kr/data/15077586/openapi.do)
    - CenterNetwork
        - Combine의 **Publisher** 생성 → API 호출 및 JSON 디코딩
            
            ```swift
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
            ```
            
    - SelectRegionViewModel
        - Combine의 **Subscriber**로 데이터 수신
            
            ```swift
            import Foundation
            import Combine
            
            class SelectRegionViewModel: ObservableObject {
                
                @Published var centers = [Center.Sido: [Center]]()
                
                private var cancellables = Set<AnyCancellable>() // disposeBag
                
                init(centerNetwork: CenterNetwork = CenterNetwork()) {
                    centerNetwork.getCenterList()
                        .receive(on: DispatchQueue.main) // View에 뿌려져야 하므로
                        .sink { [weak self] in
                            guard case .failure(let error) = $0 else { return }
                            print(error.localizedDescription)
                            self?.centers = [Center.Sido: [Center]]()
                        } receiveValue: { [weak self] centers in
                            self?.centers = Dictionary(grouping: centers, by: { $0.sido }) // sido를 key로 하는 딕셔너리 생성
                        }
                        .store(in: &cancellables) // disposed(by: disposeBag)
                }
                
            }
            ```
            
2. 시도 그리드 화면 만들기
3. 센터 리스트 화면 만들기
4. 센터 상세 화면 만들기
    - MapView 만들기(`MapKit` 활용)
        - 지도 센터 위치 설정 및 AnnotationItem으로 지도 핀 그리기
            
            ```swift
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
                
            }
            ```

