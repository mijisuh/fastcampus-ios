# 📚 도서 리뷰 앱

> - Naver 검색 API로 책을 검색하고 해당 책에 대한 서평을 작성할 수 있음
> - 작성한 서평을 리스트로 확인할 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-18 at 02 50 19](https://github.com/mijisuh/fastcampus-ios/assets/57468832/c1d3ad01-3c28-4d25-bf16-675b249a295a)

## 개념 정리

<details>
<summary>MVP Architecture</summary>

- 아키텍쳐를 사용하는 이유는 각각의 객체가 **역할 분리**가 되고 **코드가 깔끔**해지기 때문

## MVP

- **ViewController의 일을 Presenter에게 분리**

    <img width="885" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/574fe3ad-69fc-40a9-857c-428451273768">

- Presenter는 중간 관리자로 User Action이 발생하면 Model에게, Model로부터 변동 사항이 발생했을 때 ViewController에게 명령, 요청을 함

    <img width="885" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/d4dc8b13-4a76-4792-9728-42732124500c">

- User Action에 대한 Request 발생 시 흐름도
    
    <img width="885" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/25ec8fa4-482b-4898-9558-2aae11218ad4">

    <img width="885" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/d3ea5b71-7813-4b03-975a-b8061641821e">
    
- 도서 리뷰 앱
    
    <img width="885" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e0d47d91-4dfb-4b14-9f52-dccc80293b67">
    
    <img width="885" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/6d26ade4-ca7d-4f85-aa92-eed8f3973760">
    
    - ViewController → Presenter → Model
    
    <img width="885" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/73f61d7b-3d32-4df2-8ed8-9fa85e503124">
    
    - Model → Presenter → ViewController
- 각각의 객체를 인식하는 방법
    
    <img width="904" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/36745218-db11-4747-92f1-66f314aba755">
    
    - **Model과 ViewController는 무조건 Presenter를 통해서만 알 수 있고 서로를 직접적으로 알면 안됨**
    - Model ↔ Presenter
        
        <img width="1124" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2f2c3e9d-64eb-49e8-831f-a50cb00ed314">
        
        - Presenter 클래스는 Model를 변수 혹은 정수로만 가지고 있음
        - Model은 Presenter에게 직접적으로 요청할 수 없음
        - Presenter의 요청사항은 Closure 형태인 **CompletionHandler의 비동기**로서만 알려줄 수 있음
    - Presenter ↔ ViewController
        
        <img width="1219" alt="10" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f358c6cd-a832-4f22-bb91-873f83ec2324">

        <img width="1077" alt="11" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/81fc3626-a305-4f6f-bae6-af1807e1abd5">
        
        - ViewController는 Presenter를 프로퍼티로 가지고 있음
        - Presenter는 ViewController를 Protocol로 가지고 Protocol를 통해서 ViewController에 명령할 수 있음
        - Presenter는 Protocol로 미리 작성한 메서드들만 알 수 있고 내부적으로 ViewController가 어떤 컴포넌트와 메서드를 가지고 있는지는 알 수 없음
</details>

<details>
<summary>iOS 앱 개발에서의 Test</summary>

- Test란 개발자가 작성한 코드가 원하는 타이밍에 **의도한대로 작동**하는지 확인하는 과정
    - UI 표시
    - UI Layout 설정
    - API Request
    - UserDefaults 저장하기/가져오기
    - …
- Test의 종류
    - **Unit Test**
        - 특정 함수, 메서드의 동작에 대한 테스트
    - **UI Test**
        - UI 표시 or UI Action에 대한 테스트
- Xcode에서 제공하는 XCTest 프레임워크 사용
- Test 결과 확인하기
    - **Test Coverage**
        - Xcode Project에서 **몇 %의 코드에 대해서 테스트가 작성되어 있는지** 정량적으로 나타낸 숫자
    - Test Coverage의 사용
        - **App의 안정성을 확인**하는 기준
</details>

## 전체 화면 구성

<img width="885" alt="12" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4ec8d8f2-e1af-4fe3-9425-b2fb228c5183">

## 구현 내용

1. MVP Architecture에 맞게 Xcode Project 내 파일 생성하기
    
    <img width="1024" alt="13" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/6fdbb65a-0a6f-42ce-aa4a-2f96615ec2c9">
    
    - ViewController
        - Presenter를 호출해서 User Action을 알려줘야 하기 때문에 Presenter를 프로퍼티로 가지고 있음
            
            ```swift
            final class ReviewListViewController: UIViewController {
                private lazy var presenter = ReviewListPresenter(viewController: self) // self는 초기화되는 타이밍에 바로 넣으면 안됨 -> lazy
            }
            
            extension ReviewListViewController: ReviewListProtocol {
                
            }
            ```
            
    - Presenter
        - ViewController에게 변동사항을 알리기 위해 delegate 패턴 구현
            
            ```swift
            protocol ReviewListProtocol { // ReviewListViewController가 해야 할 일
                
            }
            
            final class ReviewListPresenter {
                private let viewController: ReviewListProtocol
                
                init(viewController: ReviewListProtocol) {
                    self.viewController = viewController
                }
            }
            ```
            
2. 앱 화면 구현하기
    - 도서 리뷰 목록 화면
        
        <img width="558" alt="14" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/9c04d8ad-4283-4c43-93cf-2452734c82c6">

        <img width="558" alt="15" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/827af6fb-f2f4-478e-8f0b-054a18edd914">
        
        - UITableViewDataSource는 특정한 데이터를 이용해 UITableView을 그리고 MVP 모델은 View와 관련이 없는 데이터는 모두 Presenter가 가지고 있기 때문에 UITableViewDataSource의 일은 Presenter에게 일임하는 것이 적절
        - UITableViewDelegate는 UITableView의 특정한 행동에 의해 액션을 실행
    - 도서 리뷰 작성 화면
        
        <img width="558" alt="16" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/98676e0a-845f-46fe-aaaf-9f403543303a">

        <img width="558" alt="17" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2bc633da-99e5-48e4-8313-9db3e25bd956">
        
    - 도서 검색 화면
        
        <img width="653" alt="18" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e8de312c-ba8b-4a22-b6ef-f7a108b6a838">
        
        <img width="569" alt="19" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/60f6a1bc-fcf8-45e4-9f1c-b69c160c9edf">

        <img width="772" alt="20" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/6ce0b2af-204e-4fd9-966d-45dc6c5bea96">
        
        - cell 선택 시 리뷰 도서 리뷰 목록 화면으로 해당 도서 정보 전달
        - Delegate 패턴으로 구현
            - 선택한 도서 정보를 전달하기 위한 Delegate 객체는 도서 검색 화면이 가지고 있고 도서 정보를 전달받는 도서 리뷰 목록 화면은 해당 Delegate를 준거하는 메서드를 구현
3. API 사용 신청 / 네트워크 통신 코드 구현하기
    - [참고 문서](https://developers.naver.com/docs/serviceapi/search/blog/blog.md#%EB%B8%94%EB%A1%9C%EA%B7%B8)
        
        <img width="857" alt="21" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3dce22cc-994a-4b0c-90b0-8877337ff7fe">
        
        <img width="1092" alt="22" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/dd30dbd2-d89b-4368-adb0-ba08a7605241">

        <img width="1092" alt="23" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/127c7550-ec0b-4924-9f3e-cf5cf5e0d3d8">
        
    - ViewController는 Presenter에게 API Request를 실행하는 타이밍만 알려주고 실질적으로 BookSearchManager에게 Request를 요청하는 것은 Presenter
    - SearchBookPresenter → ReviewWritePresenter
        - Delegate 패턴으로 데이터 전달
4. 도서 리뷰 저장 기능 구현하기
    - UserDefaults에 저장
        
        <img width="990" alt="24" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/faa9c1b4-8cd1-410b-86fc-f331540e8940">
        
        - UserDefaultsManager 생성
            - Protocol 기반으로 구현(Unit Test 작성 목적)
                
                ```swift
                protocol UserDefaultsManagerProtocol {
                    func getReviews() -> [BookReview]
                    func setReview(_ newValue: BookReview)
                }
                
                struct UserDefaultsManager: UserDefaultsManagerProtocol {
                    enum Key: String {
                        case review
                    }
                    
                    func getReviews() -> [BookReview] {
                        guard let data = UserDefaults.standard.data(forKey: Key.review.rawValue) else { return [] }
                        return (try? PropertyListDecoder().decode([BookReview].self, from: data)) ?? []
                    }
                    
                    func setReview(_ newValue: BookReview) {
                        var currentReviews = getReviews()
                        currentReviews.insert(newValue, at: 0) // 맨 위에 추가
                        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(currentReviews), forKey: Key.review.rawValue)
                    }
                }
                ```
                
5. XCTest를 사용해서 Unit Test 작성하기
    - ReviewWritePresenter
        - Test
            
            ```swift
            import XCTest
            @testable import BookReview
            
            final class ReviewListPresenterTests: XCTestCase {
                var sut: ReviewListPresenter! // sut: 테스트 대상
                var viewController: MockReviewListViewController!
                var userDefaultsManager: MockUserDefaultsManager!
                
                override func setUp() { // 각각의 테스트 항목이 실행될 때 실행
                    super.setUp()
                    viewController = MockReviewListViewController()
                    userDefaultsManager = MockUserDefaultsManager()
                    sut = ReviewListPresenter(
                        viewController: viewController,
                        userDefaultsManager: userDefaultsManager
                    )
                }
                
                override func tearDown() { // 각각의 테스트 항목이 종료될 때 실행
                    sut = nil
                    viewController = nil
                    
                    super.tearDown()
                }
            
                // 테스트 항목(이름의 어두가 test- 여야 함)
                func test_viewDidLoad가_호출될_때() {
                    sut.viewDidLoad()
                    
                    XCTAssertTrue(viewController.isCalledSetupNavigationBar)
                    XCTAssertTrue(viewController.isCalledSetupViews)
                }
                
                func test_viewWillAppear가_호출될_때() {
                    sut.viewWillAppear()
                    
                    XCTAssertTrue(userDefaultsManager.isCalledGetReviews)
                    XCTAssertTrue(viewController.isCalledReloadTableView)
                }
                
                func test_didTapRightBarButtonItem가_호출될_때() {
                    sut.didTapRightBarButtonItem()
                    
                    XCTAssertTrue(viewController.isCalledPresentToReviewWriteViewController)
                }
            }
            ```
            
        - Mock
            
            ```swift
            @testable import BookReview
            
            final class MockReviewListViewController: ReviewListProtocol {
                var isCalledSetupNavigationBar = false
                var isCalledSetupViews = false
                var isCalledPresentToReviewWriteViewController = false
                var isCalledReloadTableView = false
                
                func setupNavigationBar() {
                    isCalledSetupNavigationBar = true
                }
                
                func setupViews() {
                    isCalledSetupViews = true
                }
                
                func presentToReviewWriteViewController() {
                    isCalledPresentToReviewWriteViewController = true
                }
                
                func reloadTableView() {
                    isCalledReloadTableView = true
                }
            }
            ```
            
            ```swift
            @testable import BookReview
            
            final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
                var isCalledGetReviews = false
                var isCalledSetReview = false
                
                func getReviews() -> [BookReview] {
                    isCalledGetReviews = true
                    
                    return []
                }
                
                func setReview(_ newValue: BookReview) {
                    isCalledSetReview = true
                }
            } 
            ```
            
6. 테스트 결과 확인하기
    - Test Coverage 설정
        - [Edit Scheme…] → [Test] → [Test Plans] 화살표 → [Configurations] → [Code Coverage] → On → Gather coverage for 체크 → .xctestplan 파일 저장

+) SearchBook Scene의 테스트 작성하기
(Hint: SearchBookManager의 protocol을 만들어서, Mock Data 생성/주입)