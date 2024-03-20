# 🗣️ 트위터 앱

> - 트윗을 작성하고 작성한 트윗의 목록 및 상세 내용을 확인할 수 있음
> - 유저 정보를 수정할 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-20 at 17 33 39](https://github.com/mijisuh/fastcampus-ios/assets/57468832/47ea1bdf-f4c6-4077-b6d7-082a27029cd2)

## 개념 정리

<details>
<summary>앱스토어 업로드, 심사, 배포 과정</summary>

## 앱 출시 Flow
    
1. 앱 구현
2. TestFlight에 QA용 빌드 배포
    - TestFilght: 베타 테스트용 앱을 배포할 수 있는 서비스
3. QA 실시
4. 앱스토어용 빌드 배포
    - App Store Connect에서 진행
        - App Identifier 등록
            
            <img width="881" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/5e678a91-7732-48d3-bb77-149ed0ba8111">
            
            <img width="881" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f934d831-4814-4567-a0cc-e2372402f1e9">
            
            <img width="881" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3c3ae077-e48d-442d-93fa-474d2cdd276e">
            
        - App 등록
            
            <img width="939" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/683fa72b-bbfb-4c56-a3a7-cb992f5feb0a">

            <img width="694" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e9b6d713-0616-461e-8af7-e9b120f246b4">
            
            <img width="864" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/500d1474-2198-42cd-985e-e495ee0e0ac5">
            
            - 업로드된 빌드 선택
        - 심사에 필요한 정보 입력
    - Xcode에서 진행
        - Build Number, Version 확인
            
            <img width="881" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/708ffb9f-5814-45f4-852a-1190a9a6bfcf">
            
        - App Icon 등록
            - [앱 아이콘 생성](https://www.appicon.co/)
        - Archive
            - Xcode → Product → Archive
            - 비활성화된 경우 Simulator가 아닌 실제 기기를 연결하면 활성화됨
5. 앱 심사 신청
6. 심사 통과 후 앱스토어 공개
</details>

## 전체 화면 구성

<img width="982" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/9011e593-8d03-4a7e-9ca7-aa1067d69b03">

## 구현 내용

1. 트위터 글 게시 기능 구현하기
    - UserDefaults와 Codable을 사용해서 Local에 저장
2. 피드 화면 구현하기
    - UITabBarController
        
        <img width="695" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/216b16b5-f05b-4334-b954-2dc93a56b02e">
        
        - tabBarItem을 enum으로 관리
    - FeedViewController
        
        <img width="695" alt="10" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/dce1c40d-1fdc-4a01-8d47-e2781d24a18a">
        
        - 버튼 아이콘을 enum으로 관리 → 유지보수 용이
    - 글쓰기 버튼 → [Floaty](https://github.com/kciter/Floaty) 라이브러리 활용
        
        <img width="695" alt="11" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/b7cd7150-2a47-4050-a459-5214cbf6c965">
        
        ```swift
        private lazy var writeButton: Floaty = {
            let floaty = Floaty()
            floaty.sticky = true
            floaty.handleFirstItemDirectly = true // 버튼 클릭 시 세부 버튼이 나오지 않고 바로 동작
            floaty.addItem(title: "") { _ in
                print("Floaty!")
            }
            floaty.buttonImage = Icon.write.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return floaty
        }()
        ```
        
3. 트윗 상세 화면 구현하기
    - 화면 전환
        
        <img width="695" alt="12" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/bf33f200-9de6-401b-a4fd-5d56d7cf5f8e">
        
    - 트윗 상세 화면
4. 글 작성 화면 구현하기
    - 화면 전환
        
        <img width="695" alt="13" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2afe2273-2b1e-4eb4-96aa-197037e45cac">
        
    - 글 작성 화면
        
        <img width="695" alt="14" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f1aa9fe8-903a-49aa-8e52-cf643c1c0fae">
        
5. 프로필 화면 구현하기
    - UINavigationItem(title)
    - UITextField
    - UIButton
        - Static 변수의 값 Update
            
            ```swift
            private var user: User {
                get { User.shared }
                set { User.shared = newValue } // 별도의 메서드 구현 X
            }
            ```
            
6. 에러메시지 표시 기능 구현하기
    - Toast: [Toast-Swift](https://github.com/scalessec/Toast-Swift) 라이브러리 활용
        
        <img width="632" alt="15" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/cd15f7de-b980-4b01-8726-904a6b30e8e5">
        
        - 어느 하나라도 TextField가 비워진 상태로, 저장하기 버튼을 탭 → 에러메시지 표시
7. Unit Test 작성하기
    - Scene 4개
        
        <img width="957" alt="16" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/69ee95f0-0740-4e13-bf42-eb3e6fe17cd9">
