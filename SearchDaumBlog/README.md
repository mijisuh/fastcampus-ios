# 🔍 다음 블로그 검색 앱 만들기

> - RxSwift, RxCocoa를 이용하여 기본 앱 바탕을 만들 수 있음
> - Kakao API를 이용해서 포털 사이트인 다음의 블로그를 키워드로 검색해서 보여줌
> - 블로그를 이름과 날짜 기준으로 정렬해서 보여줌

![Simulator Screen Recording - iPhone 14 - 2024-03-09 at 11 51 51](https://github.com/mijisuh/fastcampus-ios/assets/57468832/fa7a3482-a1d1-4234-bd14-5c84cace2554)

## 개념 정리

<details>
<summary>Operator</summary>

## Filtering Operator

- filter
    - 클로저 내부에 true/false의 값을 리턴하는 조건문이 있어 조건문이 true인 경우에만 결과로 전달
        
        <img width="680" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/585fb721-35ed-4a4e-8253-a4a4e3905433">
        
## Transforming Operator

- map
    - Observable 타입의 객체들이 내뿜은 값을 받아서 원하는 형태로 변형하여 결과로 전달
        
        <img width="680" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/b43c4776-d553-49b1-a93c-c7faf120f0d8">

## Combining Operator

- 앞선 operator들과 마찬가지로 시퀀스 출력 값을 핸들링하여 결과를 내뿜는다는 점에서 동일하지만 **여러가지 시퀀스들을 조합할 수 있다**는 점에서 차이가 있음!
    
    <img width="680" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/16122df8-9106-412d-8f96-f3fa6edf271e">
    
    - merge: A, B 모두 같은 타입이어야 함
        
        <img width="810" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4ec3bae9-bb82-47a7-85f3-09752f302ef7">

## Time Based Operator

- **시간의 흐름에 따라** 시퀀스의 이벤트 방출이나 구독을 제어
    
    <img width="680" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/90027534-c96d-477b-b6b9-489651317161">

    - buffer: 지정한 시간과 개수만큼 이벤트를 묶어서 시퀀스로 반환

        <img width="810" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/0c60fe45-5139-430e-9f41-7f3fc06abc67">
        
</details>

<details>
<summary>RxCocoa</summary>

## Cocoa Framework

- Foundation: 기본적인 자료형과 메서드 정의
- ApplicationKit(UIKit): 주로 UI 개발에 사용

## RxCocoa

- Cocoa 프레임워크(UI 컴포넌트와 각각의 속성, 이벤트 등)를 **Rx로 감싸서 처리**할 수 있도록 도와줌
- ex. UISearchBar로 입력한 문구를 이용해 네트워크 통신을 하고 그 결과를 UITableView에 뿌려주는 기능에서 활용할 경우
    - 서로 다른 클래스(UISearchBar, UITableView)에서 비동기적으로 발생한 값을 기존 애플 API가 제공하는 방식으로 조합하고 전달하려면 구현하기 상당히 까다로울 것
    - Rx를 이용하면 간단하고 명시적으로 작성 가능
        
        <img width="532" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e5c6231c-9379-4409-b3bc-30a874e8a8c6">
        
- **Binder**
    
    <img width="812" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/bbda4806-689f-4b98-8f82-4a7fde42ac64">
    
    - **단방향** 데이터 스트림 (ex. 티비 시청)
        - Binder는 **데이터를 수신하기만 함** → Observer의 역할만
        - **UI Binding**에 사용
        - **Error 이벤트 받지 않음** → Error로 인해 시퀀스가 종료되고 더이상의 이벤트가 전달되지 않으면 Binding된 UI가 업데이트 되지 않는 문제가 발생하기 때문
        - **Main Thread에서 실행**되는 것을 보장
    - 앱의 데이터 흐름을 단순화하는 방법
    - textField에 입력이 되면 label를 업데이트 하는 코드
        
        ```swift
        textField.rx.text
        	.observe(on: MainScheduler.instance)
        	.subscribe(onNext: {
        		label.text = $0
        	})
        	.diposed(by: disposeBag)
        
        // bind를 사용해서 간결해짐
        textField.rx.text // Observable이 방출한 이벤트를
        	.bind(to: label.rx.text) // Observer에게 전달
        	.diposed(by: disposeBag)
        ```
        
- Trait
    - 에러를 방출하지 않는 특별한 Observable → onNext만 취함
    - 모든 과정은 Main Thread에서 이뤄짐
    - **스트림 공유가 가능**
        - 구독자가 생길 때마다 매번 스트림을 생성하는 것이 아닌 **공유**를 하기 때문에 리소스 낭비를 줄일 수 있음
    - asDriver나 asSingal 같은 메서드를 통해서 기존 Observable을 Driver, Signal로 전환 가능
    - **Driver**: 초기값 || 최신값 replay
    - **Signal**: 구독한 이후에 발생하는 값 전달

## Rx Extension

- 기존 CocoaFramework에서의 객체들을 **Rx 환경에서 사용할 수 있도록 커스텀**하는 방법 제공
    
    <img width="812" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/557be6be-b761-4074-b693-c9a1455a92cd">

</details>

<details>
<summary>RxSwift의 에러 관리</summary>

- 가장 흔한 에러 상황
    - 인터넷 연결 없음: 오프라인
    - 잘못된 입력: 잘못된 타입, 길이, 크기, 내용
    - API, HTTP 에러: 400, 500, JSON Codable
- catch, retry 두가지 방식 존재
    
    <img width="958" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/1995baf5-4d64-4f7a-89ae-d7bd83dda3b7">
    
    - **catch**: 에러를 잡아서 처리
        - `catch`: 클로저를 받아 새로운 형태의 Obsevable 반환
            
            `func catch(_ handler:) → RxSwift.Observable<Self.Element>`
            
            ```swift
            enum MyError: Error {
            	case anError
            	case criticalError
            }
            
            Observable.create {
            	$0.onError(MyError.anError)
            	return Disposables.create()
            }
            .catch { error in
            	switch error as! MyError {
            		case .anError:
            			return .just("괜찮아요")
            		case .criticalError:
            			return .just("펑!")
            	}
            }
            .subscribe {
            	print($0) // 괜찮아요
            }
            .disposed(by: disposeBag)
            ```
            
        - `catchAndReturn`: 에러를 무시하고 이전에 선언해둔 값을 반환 → 모든 에러에 대해 동일한 값 반환
            
            `func catchAndReturn(_ element: Self.Element) → RxSwift.Observable<Self.Element>`
            
            ```swift
            enum MyError: Error {
            	case anError
            }
            
            Observable.create {
            	$0.onError(MyError.anError)
            	return Disposables.create()
            }
            .catchAndReturn("에러 싫어")
            .subscribe {
            	print($0)
            	// next(에러 싫어)
            	// completed
            }
            .disposed(by: disposeBag)
            ```
            
    - **retry**: 에러 발생 시 특정 횟수나 상황이 발생할 때까지 재시도 시켜서 원하는 결과로 변환
        - retry: 계속 해서 재시도
            
            `func retry() → RxSwift.Observable<Self.Element>`
            
            ```swift
            enum MyError: Error {
            	case anError
            	case criticalError
            }
            
            Observable.create {
            	$0.onError(MyError.anError)
            	return Disposables.create()
            }
            .retry()
            .subscribe {
            	print($0) 
            }
            .disposed(by: disposeBag)
            ```
            
        - retry(_ maxAttemptCount:): 재시도 횟수 제한
            
            `func retry(_ maxAttemptCount: Int) → RxSwift.Observable<Self.Element>`
</details>

## 전체 화면 구현

<img width="655" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f21ae983-6925-40e3-9b97-4a7674749567">

## 구현 내용

1. SearchBar
    - 검색 버튼 클릭 이벤트 처리
        - Relay 정의(RxSwift의 Subject와 유사하지만 UI 이벤트에 특화되어 있음)
            
            ```swift
            let searchButtonTapped = PublishRelay<Void>() // onNext 이벤트만 방출
            ```
            
        - 버튼 클릭 이벤트 처리
            
            ```swift
            Observable
                .merge(
                    self.rx.searchButtonClicked.asObservable(), // SearchBar 버튼(키보드)
                    searchButton.rx.tap.asObservable() // 직접 만든 검색 버튼
                )
                .bind(to: searchButtonTapped) // 두 이벤트가 어떤 순서든 이벤트가 발생할 때마다 searchButtonTapped에 이벤트 방출
                .disposed(by: disposeBag)
            
            searchButtonTapped
                .asSignal()
                .emit(to: self.rx.endEditing) // 탭 이벤트 발생 시 키보드 내려감
                .disposed(by: disposeBag)
            ```
            
    - 입력된 텍스트를 외부로 전달
        - Observable 정의
            
            ```swift
            var shouldLoadResult = Observable<String>.of("")
            ```
            
        - searchButtonTapped가 트리거 역할
            
            ```swift
            shouldLoadResult = searchButtonTapped
                .withLatestFrom(self.rx.text) { $1 ?? "" } // 가장 최신의 text을 전달(없으면 "")
                .filter { !$0.isEmpty }
                .distinctUntilChanged() // 동일한 입력인지 확인해서 중복을 없애고 불필요한 네트워크 통신이 발생하지 않도록 함
            ```
            
2. FilterView
    - 정렬 버튼 이벤트 처리
        - Relay 정의
            
            ```swift
            let sortButtonTapped = PublishRelay<Void>() // FilterView 외부에서 관찰됨(클릭 여부만 방출)
            ```
            
        - 버튼 클릭 이벤트 처리
            
            ```swift
            sortButton.rx.tap // sortButton이 tap 되었다는 이벤트를 방출하면
                .bind(to: sortButtonTapped) // 외부에서 sortButtonTapped라는 릴레이를 바라보면 그 이벤트를 전달받을 수 있음
                .disposed(by: disposeBag)
            ```
            
3. BlogListView
    - MainViewController에서 BlogListView로 데이터 전달
        - Subject 정의
            
            ```swift
            let cellData = PublishSubject<[BlogListCellData]>()
            ```
            
        - 데이터 전달: cf. UITableViewDelegate의 cellForRowAt 메서드
            
            ```swift
            cellData
                .asDriver(onErrorJustReturn: [])
                .drive(self.rx.items) { tableView, row, data in // tableView의 items을 받아서 어떻게 전달할 것인지 결정
                    let indexPath = IndexPath(row: row, section: 0) // 첫번째 섹션
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BlogListCell", for: indexPath) as! BlogListCell
                    cell.setDate(data)
                    return cell
                }
                .disposed(by: disposeBag)
            ```
            
4. MainViewController
    - SearchBar에 입력된 텍스트로 네트워크 통신
        - SearchBar에 입력된 텍스트로 네트워크 통신
            
            ```swift
            let blogResult = searchBar.shouldLoadResult
                .flatMapLatest { query in
                    SearchBlogNetwork().searchBlog(query: query)
                }
                .share() // 스트림을 새로 만들지 않고 공유
            
            let blogValue = blogResult
                .compactMap { data -> DKBlog? in
                    guard case .success(let value) = data else { return nil }
                    return value
                }
            
            let blogError = blogResult
                .compactMap { data -> String? in
                    guard case .failure(let error) = data else { return nil }
                    return error.localizedDescription
                }
            ```
            
        - 네트워크를 통해 가져온 값을 cellData로 만듬
            
            ```swift
            let cellData = blogValue
                .map { blog -> [BlogListCellData] in
                    return blog.documents
                        .map { doc in
                            let thumnailURL = URL(string: doc.thumbnail ?? "") // String -> URL
                            return BlogListCellData(thumbnailURL: thumnailURL, name: doc.name, title: doc.title, datetime: doc.datetime)
                        }
                }
            ```
            
    - AlertAction 클릭 이벤트 처리
        - Relay 정의
            
            ```swift
            let alertActionTapped = PublishRelay<AlertAction>()
            ```
            
        - AlertSheet에서 선택한 타입 가져오기
            
            ```swift
            // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때 type
            let sortedType = alertActionTapped
                .filter {
                    switch $0 {
                    case .title, .datetime: return true
                    default: return false
                    }
                }
                .startWith(.title) // 아무 것도 선택하지 않았을 때 초기값
            ```
            
        - MainViewController → BlogListView
            
            ```swift
            Observable.combineLatest(
                sortedType, // 정렬 타입과
                cellData // 데이터가
            ) { type, data -> [BlogListCellData] in // 모이면 BlogListView에게 [BlogListCellData] 형태로 전달
                switch type {
                case .title: return data.sorted { $0.title ?? "" < $1.title ?? "" }
                case .datetime: return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() } // 최신 날짜 부터
                default: return data
                }
            }
            .bind(to: blogListView.cellData)
            .disposed(by: disposeBag)
            ```
            
    - Alert 처리
        - 통신 에러 처리 → Alert 생성
            
            ```swift
            let alertForErrorMessage = blogError
                .map { message -> Alert in // Alert로 만들어줌
                    return (
                        title: "앗!",
                        message: "예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요. \(message)",
                        actions: [.confirm],
                        style: .alert
                    )
                }
            ```
            
        - 정렬 버튼 클릭 이벤트 → Alert 생성
            
            ```swift
            let alertSheetForSorting = blogListView.headerView.sortButtonTapped
                .map { _ -> Alert in
                    return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
                }
            ```
            
        - 정렬 버튼 클릭 시 or 통신 에러 발생 시 Alert 보여주기
            
            ```swift
            Observable
                .merge(
                    alertSheetForSorting,
                    alertForErrorMessage
                )
                .asSignal(onErrorSignalWith: .empty())
                .flatMapLatest { alert -> Signal<AlertAction> in
                    let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                    return self.presentAlertController(alertController, actions: alert.actions)
                }
                .emit(to: alertActionTapped)
                .disposed(by: disposeBag)
            ```
            
            ```swift
            // Alert 액션을 받았을 때 AlertController 생성
            func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
                if actions.isEmpty { return .empty() }
                return Observable
                    .create { [weak self] observer in
                        guard let self = self else { return Disposables.create() }
                        
                        for action in actions {
                            alertController.addAction(
                                UIAlertAction(
                                    title: action.title,
                                    style: action.style
                                ) { _ in
                                    observer.onNext(action)
                                    observer.onCompleted()
                                }
                            )
                        }
                        
                        self.present(alertController, animated: true)
                        
                        return Disposables.create {
                            alertController.dismiss(animated: true)
                        }
                    }
                    .asSignal(onErrorSignalWith: .empty())
            }
            ```
            
5. KaKao REST API 활용
    - [참고 문서](https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide)
    - 개발자 사이트에서 REST API 키 발급
    - Xcode info.plist에 Key 저장(왜 하는지 모르겠음..)
        - URL types - item0 - Document Role: Editor
        - URL types - item0 - URL Schemes - item0: kakao + REST API 키
6. 네트워크 통신
    - API 호출
        
        ```swift
        func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>> { // Result는 Swift에서 기본적으로 제공하는 enum으로 성공/실패 두가지 경우를 받음
            guard let url = api.searchBlog(query: query).url else { return .just(.failure(.invalidURL)) }
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("KakaoAK ~", forHTTPHeaderField: "Authorization") // REST API Key
            
            return session.rx.data(request: request as URLRequest)
                .map { data in
                    do {
                        let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                        return .success(blogData)
                    } catch {
                        return .failure(.invalidJSON)
                    }
                }
                .catch { _ in
                        .just(.failure(.networkError))
                }
                .asSingle()
        }
        ```
        
        - URLComponents로 URL 구성
        - NSMutableURLRequest 생성
        - URLSession을 rx로 감싸서 이벤트 받아옴
    - parsing
        - JSON에 Date라는 타입이 없기 때문에 커스텀한 파싱 함수 필요
            
            ```swift
            extension Date {
                
                // CodingKey -> Date
                static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
                    guard let dateString = try? values.decode(String.self, forKey: key),
                          let date = from(dateString: dateString)
                    else { return nil }
                    return date
                }
                
                static func from(dateString: String) -> Date? {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // API마다 포맷이 다르므로 문서 확인 필요
                    dateFormatter.locale = Locale(identifier: "ko_kr")
                    
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        return nil
                    }
                }
                
            }
            ```
