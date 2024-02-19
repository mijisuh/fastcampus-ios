# LED 전광판 앱

> 표시할 텍스트와 텍스트 색상, 배경 색상을 설정 화면에서 설정하고 LED 전광판 화면을 보여준다. 🌌

![Simulator Screen Recording - iPhone 14 - 2024-02-19 at 17 38 47](https://github.com/mijisuh/fastcampus-ios/assets/57468832/52e2155f-3db2-410f-8748-a3025d925d72)

## 주요 개념 정리

<details>
<summary>UINavigationController</summary>

### Content View Controller
  - 화면을 구성하는 뷰를 직접 구현하고 관련된 이벤트를 처리하는 뷰 컨트롤러
  - 스토리보트 생성 시 일반적으로 생성되는 뷰 컨트롤러

### Container View Controller
- 하나 이상의 Child View Controller를 가지고 있음
- 하나 이상의 <u>Child View Controller를 관리</u>하고 <u>레이아웃과 화면 전환을 담당</u>함
- 화면 구성과 이벤트 관리는 Child View Controller에서 함
- 대표적으로 `UINavigationController`, `UITabBarController`

### UINavigationController
- 계층구조로 구성된 contents를 순차적으로 보여주는 Container Controller
- **Navigation Stack**이라고 하는 정렬된 배열을 사용하여 자식 뷰 컨트롤러를 관리
  - 배열의 첫번째 컨트롤러는 Root ViewController(스택의 최하단)
  - 배열의 마지막 컨트롤러는 Child ViewController(스택의 최상단)
- Segueway나 UINavigationController 메서드로 스택에 뷰 컨트롤러 추가/제거 가능
    - back 버튼이나 swipe 제스쳐로 제거 가능
- Navigation Bar: 화면 상단에 항상 보여지는 바

</details>


<details><summary>화면 전환 방법</summary>

- 구현 방식
    1. 소스 코드를 통해 전환하는 방법
    2. 스토리보드를 통해 전환하는 방법
- 구체적인 구현 방식
    1. ViewController의 View 위에 다른 View를 가져와 바꿔치기 **메모리 누수 위험이 있어 사용하지 X

    2. ViewController에서 **다른 ViewController를 호출**하여 전환하기
        
        ```swift
        func present(
            _ viewControllerToPresent: UIViewController, // 전환할 화면의 ViewController 인스턴스
            animated flag: Bool, // 화면을 전환할 때 애니메이션 효과 여부
            completion: (() -> Void)? = nil // 화면이 전환되는 시점에 호출
        )
        
        func dismiss(
            animated flag: Bool, // 이전 화면으로 돌아갈 때 애니메이션 효과 여부
            completion: (() -> Void)? = nil // 이전 화면으로 돌아가는 것이 완료되면 호출
        )
        ```
        
        - 직접 표시한다고 하여 <u>presentation 방식</u>이라고 함
        - 화면 전환은 비동기 방식으로 처리되기 때문에 화면 전환이 완료된 이후에 처리해야 할 사항이 있을 경우 completion 클로저에 로직 작성
    3. **NavigationController**를 사용하여 화면 전환하기
        
        ```swift
        func pushViewController(
            _ viewController: UIViewController,
            animated: Bool
        )
        
        func popViewController(animated: Bool) -> UIViewController?
        ```
        
        - <u>계층적인 성격을 띄는 콘텐츠 구조를 관리</u>하기 용이
        - ViewController의 전환을 직접 컨트롤하고 앱의 네비게이션 정보를 표시하는 것뿐만 아니라 네비게이션 스택으로 자식 뷰 컨트롤러를 관리
        - Left edge swipe가 자동으로 적용(presentation 방식은 X)
    4. 화면 전환용 객체 **세그웨이(Segueway)** 를 사용하여 전환하기
        - 2개의 ViewController 사이에 연결된 화면 전환 객체
        - <u>스토리보드를 통해</u> 출발지와 목적지를 직접 지정
        - 소스코드를 추가하지 않아도 화면 전환 구현 가능
        - **Action Segueway**: 출발점이 버튼, cell 등 인 경우
            - 버튼 터치 등 트리거 이벤트가 세그웨이 실행으로 바로 연결
            - `Show`: 네비게이션 컨트롤러 사용시 네비게이션 스택에 쌓이게 되고 네비게이션을 사요하지 않을 경우는 present
            - `Show Detail`: Split View에서 사용(아이폰에서는 Show 세그웨이와 동일하게 동작하지만 아이패드에서는 split(master slave) 구조로 보임)
            - `Present Modally`: 이전 뷰 컨트롤러를 덮으면서 새로운 화면이 나타남(presentation 방식으로 화면이 전환되는 거라고 생각)
            - `Present As Popover`: 아이패드에서 팝업 창을 띄울 때 사용(아이폰 X)
            - `Custom`: 세그웨이를 사용자가 원하는 방식으로 커스텀할 때 사용

       - **Manual Segueway**: 출발점이 뷰 컨트롤러 자체인 경우
          - 적절한 시점에 performSegue라는 메서드 호출
</details>


<details><summary>UIViewController Life Cycle</summary>

- UIViewController의 객체에는 View 객체들을 관리하는 메서드들이 정의되어 있음
- 뷰의 상태 변화에 따라 <u>각 메서드들이 불러져야 하는 타이밍일 때</u> iOS 시스템에 의해 자동으로 호출됨
- UIViewController의 하위 클래스를 생성할 때 UIViewController에 정의된 이 메서드들을 override하여 **Life Cycle 상황에 맞게 적절한 로직들을 추가**할 수 있음
    - `viewDidLoad()`
        - 뷰컨트롤러의 <u>모든 뷰들이 메모리에 로드됐을 때</u> 호출
        - <u>메모리에 처음 로드될 때 한번만</u> 호출
        - 보통 딱 한 번 호출된 행위들을 이 메소드 안에 정의
        - 뷰와 관련된 추가적인 초기화 작업, 네트워크 호출
    - `viewWillAppear()`
        - 뷰가 <u>뷰 계층에 추가되고 화면에 보이기 직전에 매번</u> 호출
        - 다른 뷰로 이동했다가 돌아오면 재호출
        - 뷰와 관련된 추가적인 초기화 작업
    - `viewDidAppear()`
        - 뷰컨트롤러의 <u>뷰가 뷰 계층에 추가된 후</u> 호출
        - 뷰를 나타낼 때 필요한 추가 작업
        - 애니메이션을 시작하는 작업
    - `viewWillDisappear()`
        - 뷰컨트롤러의 <u>뷰가 뷰 계층에서 사라지기 직전에 </u>호출
        - 뷰가 생성된 뒤 작업한 내용을 되돌리는 작업
        - 최종적으로 데이터를 저장하는 작업
    - `viewDidDisappear()`
        - 뷰컨트롤러의 <u>뷰가 뷰 계층에서 사라진 뒤에</u> 호출
        - 뷰가 사라지는 것과 관련된 추가 작업
</details>


<details><summary>화면 간 데이터 전달하기</summary>

- **코드로 구현된 화면 전환 방법**에서 데이터 전달하기
    - `instantiateViewController()` 메서드를 이용해서 스토리보드에 있는 뷰를 인스턴스화하고 각 프로퍼티에 접근하여 데이터 전달
- **세그웨이로 구현된 화면 전환 방법**에서 데이터 전달하기
    - `prepare()` 메서드를 오버라이드해서 전환하려는 뷰컨트롤러의 인스턴스를 가져와 프로퍼티에 접근하여 데이터 전달
- **Delegate 패턴**을 이용하여 이전 화면으로 데이터 전달하기
</details>



## 구현 내용
1. 스토리보드에 Navigation Controller 추가
    - Root View Controller는 LED 화면 뷰 관리

2. LED 화면 뷰에 Bar Button 추가해서 클릭 시 설정 화면으로 이동하도록 Segueway action 설정(Show)
3. 설정 화면 뷰에 라벨과 텍스트필드 추가
    - `UITextField`: 텍스트를 편집하기 위한 객체, 여러 줄 사용 불가(UITextView 객체 사용해야 함)
    - `UIStackView`로 라벨과 텍스트필드를 한 세트로 묶음(적용할 뷰를 모두 선택 → Embed In 클릭 → Stack View)
    - 스택 뷰 속성 인스펙트에서 Spacing 속성으로 간격 조정
4. 리소스 파일 관리(에셋 카탈로그)
    - `Assets.xcassets`에서 추가 및 관리
        - Image Set에는 <u>1x, 2x, 3x</u>의 이미지 리소스를 추가해야 함(각각 24, 48, 72 픽셀 사이즈)
        - <u>다양한 해상도에서 이미지 리소스가 깨지지 않게</u> 하기 위함 → 아이폰에서 자동으로 알맞은 사이즈로 적용
5. Button에 이미지 적용
    - Assets에 추가한 이미지 리소스 적용
    - 첫 번째 버튼을 제외한 버튼들의 alpha 값을 0.2로 적용(클릭한 경우만 1)
6. ViewController 클래스 생성 및 연결
7. IBOutlet 변수, IBAction 함수 정의
    - 여러 개의 버튼을 하나의 액션 함수에 연결 가능 -> 어떤 버튼이 클릭되었는지는 Action 함수에 전달되는 <u>sender 파라미터</u>로 알 수 있음
    - 각 아울렛 변수가 클릭되었을 때 클릭한 버튼의 색만 진하게 함
8. 이전 화면(설정 뷰 → LED 화면 뷰)에 데이터 전달
    - **Delegate 패턴 이용**
    - 설정 뷰에 Delegate 프로토콜을 정의하고 저장 버튼 클릭 시 delegate 함수를 호출하여 설정 값을 전달
    - LED 화면 뷰에 Delegate 프로토콜을 채택하고 요구사항 정의
9. LED 화면 뷰 → 설정 뷰에서 설정 값이 초기화되는 현상
    - LED 화면 뷰 → 설정 뷰로 데이터 전달
    - 설정 뷰 `viewDidLoad()`에 초기화 작업 진행해서 설정된 값이 유지되도록 함


