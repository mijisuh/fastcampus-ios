# 🎬 영화 앱 

> - 영화를 검색해서 평점, 배우, 감독, 제작년도에 대한 정보를 확인할 수 있음
> - 특정 영화를 즐겨찾기로 등록해서 리스트 형태로 확인할 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-20 at 09 57 42](https://github.com/mijisuh/fastcampus-ios/assets/57468832/d1bceaa1-012d-45a6-9b25-aab2b29f2a30)

## 개념 정리

<details>
<summary>SwiftLint</summary>

- 팀 개발에서 각각의 코드 스타일은 모두 다를 수 밖에 없음
    - Indent, reture 생략, …
- 하나의 Xcode Project 내에서 Swift 코드 스타일을 통일시킬 수 있도록 도와주는 프레임워크
- **작성된 코드가 룰에 위반**될 때, 강제적으로 컴파일 에러를 발생시켜 빌드 실패 또는 빌드 경고를 표시
- .swiftlint.yml 파일을 이용해 커스텀 가능
    - 자동으로 생성되지 않아서, 수동으로 추가해야 함
- SwiftLint 설치
    - CocoaPods
        - Xcode Project마다 설치
        - pod ‘SwiftLint’
        - Xcode Project Build Phase(빌드 전 해야 할 일에 대한 명령)에 SwiftLint을 실행시키는 스크립트 추가: **${PODS_ROOT}/SwiftLint/swiftlint**
    - Homebrew
        - Mac Local 자체에 설치
</details>

<details>
<summary>iOS 앱 개발에서 UI Test</summary>

## UI Test

- UI Component의 표시와 동작이 의도한대로 잘 작동하는지 확인하는 Test
- Unit Test는 Scene을 테스트 대상으로 실행
    - `class MovieListPresenterTests: XCTest {}`
- UI Test는 **하나의 앱을 테스트 대상으로 실행**
    - `XCUIApplication().launch()`
- 예시
    - UINavigationBar의 title에서 “영화 평점”이 표시되고 있는가
    - UINavigationBar에서 SearchBar가 표시되고 있는가
    - UISearchBar에서 Cancel Button이 표시되고 있는가
</details>

<details>
<summary>BDD</summary>

## BDD

- Behavior Driven Develop
- **시나리오를 기반**으로 테스트 케이스를 작성하는 테스트 작성 방법
    - **테스트 작성 구조(진행 흐름)**
        - **Given**: A의 상태에서 → *네트워크 통신이 실패하는 상태에서*
        - **When**: B가 실행될 때, → *유저가 새로고침 버튼을 탭 했을 때, (새로고침 버튼을 탭 하지 않으면)*
        - **Then**: C가 실행되어야 한다. → *유저에게 에러 메시지를 보여줘야 한다. (에러 메시지를 보여주면 안된다.)*
</details>

## 전체 화면 구성

<img width="880" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/a728a319-6a15-49ca-a077-263280ed82c6">

## 구현 내용

1. Xcode에서 SwiftLint 설정하기
2. 네이버 영화 API 사용 신청 및 네트워크 통신 코드 구현하기
    - API
        - [KMDb - 영화 상세 정보](https://www.kmdb.or.kr/info/api/apiDetail/6)
3. 영화 검색 화면의 UI 구현하기
    
    <img width="733" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/8db5b3be-d95e-44f1-b093-04addfa1c8d1">
    
    - SearchBar
        
        <img width="733" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2a7a589f-8eca-41a5-a9cc-274bbbedabff">
        
    - CollectionView, TableView
        
        <img width="733" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/7ad4da77-7061-4721-b2f9-22283398bf91">
        
        <img width="733" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/0fcecbde-c0e3-4976-a823-dac86b78e149">
        
4. 영화 평점 화면의 UI 구현하기
    - 화면 전환
        
        <img width="933" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/12605b97-78b0-47b9-a7f0-286d6c8f1e26">
        
        - CollectionView Cell
        - TableView Cell
    - NavigationBar
        
        <img width="626" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/aa37bc9c-fae8-43b3-b0e3-af45aaa4bf4c">
        
        <img width="821" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3d3dca27-31f6-411b-854f-84d567c3ecb5">

        <img width="821" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/641b0ba4-10e6-42d4-a5a6-5ee342987474">
        
5. BDD를 따르는 Unit Test 작성하기
6. BDD를 따르는 UI Test 작성하기
    - Given: 즐겨찾기에 등록되어 있고(등록되어 있지 않고)
    - When: Cell이 그려지면
    - Then: 목록에 즐겨찾기한 영화가 표시된다.(표시되지 않는다.)
7. 테스트 결과 확인하기
    - Test Coverage

