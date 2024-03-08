# GitHub 앱 만들기

> - GitHub API를 이용해서 앱에 GitHub 계정에 있는 레파지토리 목록을 불러올 수 있음
> - 선언형 프로그래밍으로 iOS 앱을 개발하기 위해 RxSwift를 활용함

![Simulator Screen Recording - iPhone 14 - 2024-03-08 at 15 21 09](https://github.com/mijisuh/fastcampus-ios/assets/57468832/0b497954-a0ce-4c6a-954d-f4a6426531b7)

## 개념 정리

<details>
<summary>RxSwift 1</summary>

## RxSwift

- **비동기적으로 움직이는 애플의 API들과 수시적으로 상태가 변하는 환경**에서 보다 직관적이고 효율적인 코드를 작성할 수 있도록 도와줌
- Bindings
    
    <img width="810" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/acf932b6-e29d-4f45-a97a-66b7810ba50e">
    
    - `Observable` 라는 객체를 통해서 **이벤트의 흐름을 표현**
        - `bind`를 통해 UI 코드 작성(구체적으로는 `RxCocoa`에서 제공하는 개념)
        - operator들을 통해서 Observable이 내뱉는 이벤트 속의 값들을 여러 형태로 조합하고 변경
    - DispatchQueue로 스레드 작업을 지정해주지 않아도 자동적으로 처리
- 재시도
    
    <img width="995" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/1e24347a-b541-4fb9-b4f4-631501fc9c44">
    
    - API 통신을 기반으로 한 앱은 언제든 API 콜이 실패할 수도 있는데 **재시도 기능을 구현하기 용이**
        - 기본적으로 제공하는 `retry` 연산자
- Delegate
    
    <img width="1008" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4acea33e-a6ab-4d38-930b-341b7935b343">
    
    - 어떤 뷰의 delegate을 설정해줬는지 명시적으로 확인 가능
        - 기존 코드와 비교
            
            <img width="1016" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/306c86d0-5971-4975-b5c2-4f8c1b37f2fe">
            
- 사용하면 좋은 점
    - Composable
    - Reusable
    - Declarative: operator를 통해 데이터만 변경
    - Understandable and concise
    - Stable: 상태를 저장하기보다는 앱을 단방향 흐름으로 모델링하기 때문에 안정적
    - Less stateful
    - Without leaks

## 비동기 API

- 애플이 iOS SDK 내에서 비동기식 코드를 작성할 수 있도록 제공하는 다양한 API들
    - Notification Center, The delegate pattern, Grand Central Dispatch(GCD), Closures
- 일반적으로 대부분의 클래스들은 비동기적으로 작업을 수행하고 모든 UI 구성요소들은 본질적으로 비동기
    - 어떤 코드를 작성했을 때 정확히 어떤 순서로 작동하는지 가정하는 것은 불가능
    - 앱의 코드는 사용자 입력이나 네트워크 활동, 기타 OS 이벤트와 같은 다양한 외부 요인에 따라서 완전히 다른 순서로 실행될 수 있음
- 따라서 위의 방식들로 복합적인 비동기 코드를 구현 시 **부분 별로 나눠 쓰기 어렵고 추적하기도 힘듬**
</details>

<details>
<summary>RxSwift 2</summary>

## RxSwift

- 배경
    - 대부분의 코드는 **외부 이벤트에 대한 응답**에 대한 것으로 구성 → 코드를 복잡하게 만드는 요인!
        - 사용자의 컨트롤 조작 시 응답할 IBAction 핸들러
        - 키보드 위치 변경을 감지하기 위한 Notification 관찰
        - URLSession이 데이터를 응답할 때 실행할 클로저
        - KVO를 사용해서 변수의 변경 사항을 감지
    - 호출에 대한 응답 코드에 대한 일관적인 시스템의 요구가 커짐
- 구성 요소
    - **Observable(= Observable Sequence = Sequence)**
        
        ```swift
        Observable<T>
        ```
        
        - iOS의 기본적으로 제공하는 `Sequence` 타입과 동일(배열과 같이 개별 요소들을 하나씩 순회 가능)
        - **T 형태의 데이터 snapshot을 전달**할 수 있는 **일련의 이벤트를 비동기적으로 생성**하는 기능
        - 일정 기간 동안 계속해서 이벤트 생성(emit) → 다른 클래스에서 만든 값을 시간에 따라서 읽을 수 있음
            
            <img width="803" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3f785e33-551f-4c58-9a68-4ab6fc672d5f">
            
        - **하나 이상의 Observers**(Observable을 바라보는 관찰자)**가 실시간으로 어떤 이벤트에 반응** → UI 처리에 활용 가능
        - 세 가지 유형의 이벤트만 방출
            
            ```swift
            enum Event<Element> {
            	case next(Element) // 다음(최신) 데이터 전달
            	case error(Swift.Error) // Error를 발생시켜서 추가적으로 이벤트를 발생하지 않음
            	case completed // 성공적으로 일련의 이벤트들을 종료
            }
            ```
            
        - Finite Observable (ex. 인터넷 통신을 통해서 파일을 다운로드 받는 상황)
            
            <img width="806" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ef4c7164-3ea2-41a7-b2d8-6d28eea7e890">
            
            <img width="795" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f3867598-ce80-4a44-b584-9d8e871c0bc2">
            
        - Infinite Observable (ex. 기기의 가로, 세로 모드에 따라 반응(대부분의 UI 이벤트들은 무한한 시퀀스로 동작)
            
            <img width="791" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/18f8d158-f1f6-4eef-9107-8403bd82c5fa">
            
        - Marble Diagram: 시간의 흐름에 따라서 값을 표시하는 방식([참고](https://rxmarbles.com/))
    - **Operator**
        - Observable의 이벤트를 입력 받아서 **결과로 출력**하는 연산자
        - 다양한 형태로 값을 걸러내거나 변형하거나 하나로 합칠 수 있음: `filter`, `map`
            
            <img width="791" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/31d7743f-e203-4fac-845d-4ef61cef2fc5">
            
    - **Scheduler**
        - RxSwift에는 여러가지 Scheduler가 미리 정의되어 있고 대부분의 일반적인 상황에서 사용 가능 → 직접적으로 생성하거나 커스텀 할 일은 거의 없음
            
            <img width="988" alt="10" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/24de1e3c-b5fe-4a31-ba9f-8d8a60139769">
            
        - RxSwift의 DispatchQueue와 같음: Main Scheduler, Background Scheduler
- 설치
    - CocoaPods: `pod ‘RxSwift’, ‘6.2.0’`, `pod ‘RxCocoa’, ‘6.2.0’`
</details>

<details>
<summary>Observable</summary>

## Observable

- 생명주기
    
    <img width="763" alt="11" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/5a11460c-4440-4025-b00c-ce82535fdff7">
    
    - Observable은 어떤 구성 요소를 가지는 **next 이벤트**를 계속해서 방출 할 수 있음
    - Observable은 다음 이벤트를 방출하여 완전히 종료되었음을 나타낼 수 있음
        - | : **completed 이벤트**
        - X : **error 이벤트**(`Swift.Error` 인스턴스를 가지고 있음)
</details>

<details>
<summary>Trait</summary>

- 코드 가독성을 높히기 위해 좁은 범위의 Observable 사용
    - Single, Maybe, Completable
- Observable의 제한된 버전

## Single

- **success 또는 error 이벤트를 한 번만 방출**
    
    <img width="972" alt="12" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/75470aa3-69dd-4c28-b485-8f411bf4b8ad">
    
    - success = next + completed
        - 파일 저장이나 다운로드, 디스크에서 데이터 로딩과 같이 기본적으로 **값을 산출하는 비동기적 연산**에 사용
        - ex) 사진 저장하는 Obsevable에서 사진 저장에 성공했는지 혹은 실패했는지에 대해 **정확히 한 가지의 요소만을 방출**하는 연사자를 맵핑할 때 유용
    - `Observable.asSingle`, `Single.~`

## Maybe

- Single과 비슷
    
    <img width="1149" alt="13" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/12c4e0be-4192-4487-83ae-453646118cca">
    
    - Single과 유일하게 다른 점은 아무런 값을 방출하지 않는 형태의 completed 포함
        - ex) 커스텀한 포토 앨범에서 만든 앨범에 대한 ID를 UserDefaults에 저장하고 Maybe 메서드를 통해 상황 관리 가능 → 만약 ID가 존재하는 경우 그냥 completed 이벤트 방출하고 앨범을 생성하거나 삭제하는 경우는  ID와 함께 success 이벤트 방출 가능하기 때문에 UserDefaults에서 ID 보존 가능
    - `Observable.asMaybe`, `Maybe.~`

## Completable

- Completable은 어떠한 값도 방출하지 않음
    
    <img width="1149" alt="17" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/52f937ec-9af2-47e8-9401-9608c1a2f8b6">
    
    - Observable을 Single, Maybe처럼 Completable로 바꿀 수 없음 → asCompletable(X)
        - **completed, error 이벤트만을 방출**하기 때문에 값 요소를 방출하는 Observable로 변환 불가
    - `Completable.create`
    - 동기식 연산에 성공 여부를 확인할 때 유용
        - ex) 유저가 어떤 작업을 수행하는 동안 어떠한 데이터가 자동으로 저장되는 기능을 구현하기 위해서는 백그라운드 큐에서 비동기적으로 작업을 한 다음에 완료가 되면 노티를 띄우거나 에러가 나면 알럿을 표시 → 완료 여부만 확인하면 되기 때문에 값이 필요 없음
</details>

<details>
<summary>Subject</summary>

## Subject

- **Observable이자 Observer**
- 실시간으로 Observable에 새로운 값을 추가하고 subcribe에게 방출할 수 있음
- 종류
    - **PublishSubject**
        
        <img width="780" alt="14" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/7eced4fb-e795-4e55-ada8-d967bb000d27">
        
        - **빈 상태로 시작하여 새로운 값만을 subscriber에 방출**
        - 구독된 순간 새로운 이벤트 수신을 알리고 싶을 때 용이
        - 첫번째 줄: PublishSubject
            - 아래 방향 화살표: 이벤트 방출
            - 위 방향 화살표: 구독 선언
    - **BehaviorSubject**
        
        <img width="780" alt="15" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/1b87dd18-6a03-4781-9ca1-020bc0e7dfc7">
        
        - **하나의 초기값을 가진 상태로 시작**하여, 새로운 subscriber에게 초기값 또는 최신값을 방출
        - **마지막 next 이벤트를 새로운 구독자에게 반복**한다는 점을 제외하면 PublishSubject와 유사
            - 두번째 줄 구독자는 1 이벤트가 방출한 뒤에 구독했지만 직전의 값인 1 이벤트를 받음
    - **ReplaySubject**
        
        <img width="779" alt="16" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2dc695fa-8a21-4b63-9611-fe086bd851a6">
        
        - **버퍼를 두고 초기화**하며, 버퍼 사이즈 만큼의 값들을 유지하면서 새로운 subscriber에게 방출
        - Subject를 생성할 때 **선택한 특정 크기까지 방출하는 최신 요소를 일시적으로 버퍼로 저장**하고 구독자가 생길 때마다 방출
        - **버퍼는 메모리가 가지고 있어** 이미지나 대량의 배열같이 메모리를 크게 차지하는 값들을 큰 사이즈의 버퍼가 가지고 있게 하면 메모리 부하가 커짐
        - 첫번째 줄: ReplaySubject(버퍼 사이즈: 2)
            - 두번째 줄 구독자는 Subject 생성할 때부터 구독하므로 처음부터 이벤트를 받음
            - 세번째 줄 구독자는 구독할 때 버퍼 사이즈 개수만큼 이벤트를 받음
</details>

~> 그 외의 문법들은 [RxSwiftPractice](https://github.com/mijisuh/fastcampus-ios/tree/main/RxSwiftPractice) 레포 참조

## 구현 내용
1. UITableViewController + Custom Cell
2. RefreshController로 당겨서 새로고침 할 때마다 GitHub API 호출
    - GitHub API 연결하기
        - [참고 문서](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28)
    - `RxSwift`와 `RxCocoa`를 이용해서 네트워크 연결
        - Repository 타입의 데이터 모델 생성
        - BehaviorSubject와 DisposeBag 생성
            
            ```swift
            private let repositories = BehaviorSubject<[Repository]>(value: [])
            private let disposeBag = DisposeBag()
            ```
            
        - fetch 함수 정의: organization → [Repository] → Observable<Repository>로 변환
            
            ```swift
            private func fetchRepositories(of organization: String) {
                Observable.from([organization])
                    .map { organization -> URL in
                        return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
                    }
                    .map { url -> URLRequest in
                        var request = URLRequest(url: url)
                        request.httpMethod = "GET"
                        return request
                    }
                    .flatMap { urlRequest -> Observable<(response: HTTPURLResponse, data: Data)> in
                        return URLSession.shared.rx.response(request: urlRequest) //.rx: Swift에서 기본적으로 제공하는 인자들을 rx로 변환
                    }
                    .filter { response, _ in
                        return 200..<300 ~= response.statusCode
                    }
                    .map { _, data -> [[String: Any]] in
                        guard let json = try? JSONSerialization.jsonObject(with: data),
                              let result = json as? [[String: Any]]
                        else { return [] }
                        return result
                    }
                    .filter { result in
                        result.count > 0
                    }
                    .map { objects in
                        return objects.compactMap { dic -> Repository? in // compactMap은 자동적으로 nil 값은 제거해서 반환
                            guard let id = dic["id"] as? Int,
                                  let name = dic["name"] as? String,
                                  let description = dic["description"] as? String,
                                  let starGazersCount = dic["stargazers_count"] as? Int,
                                  let language = dic["language"] as? String
                            else { return nil }
                            
                            return Repository(
                                id: id,
                                name: name,
                                description: description,
                                starGazersCount: starGazersCount,
                                language: language
                            )
                        }
                    } // 구독을 하기 전까지는 아무런 역할을 하지 않음
                    .subscribe(
                        onNext: { [weak self] newRepositories in
                            self?.repositories.onNext(newRepositories) // repositories는 초기값이 아닌 newRepositories 값을 받음
                            
                            // 아직 UI Bind를 배우지 않아서 DispatchQueue 사용
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                                self?.refreshControl?.endRefreshing()
                            }
                        }
                    )
                    .disposed(by: disposeBag)
            }
            ```
            
        - UITableViewController의 refresh 설정
            
            ```swift
            refreshControl = UIRefreshControl()
            
            let refreshControl = refreshControl!
            refreshControl.backgroundColor = .systemBackground
            refreshControl.tintColor = .darkGray
            refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침") // 인디케이터 아래에 있는 글자
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            ```
            
        - Refresh의 target 메서드 정의
            
            ```swift
            @objc private func refresh() {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let self = self else { return }
                    self.fetchRepositories(of: organization)
                }
            }
            ```