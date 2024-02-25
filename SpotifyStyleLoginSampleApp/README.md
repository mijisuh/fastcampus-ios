# Spotify 스타일 로그인 앱

> - 파이어 베이스 인증을 이용하여 로그인 기능 구현
> - 이메일, 비밀번호로 로그인
> - 구글 로그인

![Simulator Screen Recording - iPhone 14 - 2024-02-25 at 23 18 23](https://github.com/mijisuh/fastcampus-ios/assets/57468832/33c0fdfc-a8ee-4d02-bcf9-64a2e3ac3970)

## 주요 개념 정리

<details>
<summary>Firebase - Auth</summary>

## Firebase

- 프론트엔드 개발에 필요한 여러 플랫폼을 제공하는 서비스
- 백엔드의 다양한 기능들을 **별도의 서버 개발없이 서버리스로 대체**할 수 있는 여러 플랫폼을 제공
    - **Cloud Firebase**, **Realtime Database**: 실시간으로 발생하는 여러 데이터를 저장하고 저장한 데이터를 불러오고 수정, 삭제 가능
    - **Cloud Messaging**: 전체 사용자 혹은 특정 사용자에게 Push 알림을 원격으로 보내기 위한 서버 구축
    - **Google Analytics**: 특정 세그먼트에 해당하는 사용자를 분류, 사용자 행동 분석, 데이터 수집
    - **A/B Testing**, **Remote Config**: 분류한 사용자에게 별도의 화면이나 메세지를 보여주는 것

## Firebase Auth

- 어려운 Signin 기능을 쉽고 안전하게 구현 가능하도록 도와주는 플랫폼
- OAuth 2.0, OpenID Connect 등의 업계 표준 활용, 삽입형 인증 솔루션 제공
- Firebase UI를 제공하여 기본적인 형태의 UI를 바로 사용할 수 있음
- 다양한 인증 방식 제공
    - 이메일/비밀번호, ID 공급 업체, 전화번호, 커스텀 인증, 익명 인증
- 별도 Backend 개발 없이 인증 서비스 제공
    - Serverless framework

## OAuth란

- **사용자 인증 방식에 대한 업계 표준**
- ID/PW을 노출하지 않고, OAuth를 사용하는 업체의 API 접근 권한을 위임 받음
- 기본 개념
    - **User**: Service Provider에게 계정을 가지고 있는 사용자
    - **Consumer**: Service Provider의 API(제공 기능)을 사용하려는 서비스(앱, 웹 등)
    - **Service Provider**: OAuth를 사용하여 API를 제공하는 서비스
    - **Access Token**: 인증 완료 후 Service Provider의 제공 기능을 이용할 수 있는 권한을 위임받은 인증 키
- 로그인 흐름
    1. User → Consumer(Spotify 샘플 앱) : google로 로그인 요청
    2. Consumer(Spotify 샘플 앱) → Service Provider(Google) : Request Token(권한 위임에 대한 요청)
    3. Service Provider(Google) → User : 권한 위임 확인 요청
    4. User → Service Provider(Google) : 권한 위임 승인
    5. Service Provider(Google) → Consumer(Spotify 샘플 앱): Access Token(Service Provider가 갖고 있는 User의 일부 정보에 접근할 수 있는 키이고 보통 로그인 서버에서 관리하지만 파이어베이스 인증이 대신 해줌)
- Firebase 인증 제공 업체
    - **이메일/비밀번호**
    - 전화
    - **Google**
    - Play 게임
    - 게임 센터
    - Facebook
    - Twitter
    - GitHub
    - Yahoo
    - Microsoft
    - **Apple**
    - 익명
</details>

## 구현 내용

1. UI 구현
    - 3개의 뷰 컨트롤러
      - LoginViewController: 앱에 진입했을 때 보여지는 메인 화면
      - EnterEmailView: 이메일, 비밀번호 입력 화면
      - MainViewController: 로그인 완료 후 보여지는 화면
2. 앱에 Firebase 연결
    - 파이어베이스 콘솔
        - 프로젝트 추가
        - iOS 어플리케이션 등록 → plist 다운로드 후 Xcode에 추가
    - 코코아팟으로 파이어베이스 SDK 설치 → `pod 'Firebase/Auth’`
    - 워크스페이스 파일에서 작업
    - `AppDelegate`에 파이어베이스 초기화 코드 추가
        ```swift
        import Firebase
        FirebaseApp.configure()
        ```
3. **이메일/비밀번호로 로그인 구현**
    - 파이어베이스 콘솔 → Authentication 시작하기 → 로그인 메서드 → 이메일/비밀번호 사용 활성화
    - Firebase Auth SDK에서 제공하는 `createUser()` 메서드로 신규 사용자 생성
        ```swift
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in // 클로저로 결과값 받음
            guard let self = self else { return }
            self.showMainViewController()
        }
        ```
    - 이미 가입된 계정 정보일 경우 에러 발생 → `signIn()` 메서드 사용
    - 로그아웃 → `signOut()` 메서드 사용
4. **구글 로그인 구현**
    - 파이어베이스 콘솔 → Authentication 탭 → 로그인 메서드 → Google 사용 설정
    - 코코아팟 설치 → `pod 'GoogleSignIn’`
    - 구글 로그인을 사용하려면 맞춤 URL 스키마를 구성해야 함
        - 프로젝트 설정 → TARGETS → Info → URL Types 추가
        - 파이어베이스 연결 시 추가했던 GoogleService-Info.plist의 REVERSED_CLIENT_ID 값을 URL Schemes에 붙여넣기
        - 앱 서비스 마다 다른 값을 가지고 있는데 이 값을 통해 구글이 권한을 위임 할 서비스를 구분
    - 구글 로그인 버튼을 UIButton → `GIDSignInButton`로 변경
        - GIDSignInButton은 UIButton을 상속 받으면서 구글 로그인을 실행시켜주는 GoogleSignIn SDK의 객체
    - 구글 로그인 창에 로그인 해서 구글 ID Token(Access Token)을 부여 받을 수 있지만 이를 파이어베이스 사용자 인증 정보로 전달하는 과정이 빠져서 아무런 처리가 안됨
    - 로그아웃은 각 인증 업체 별 로그아웃이 아닌 파이어베이스 인증 값에 대한 로그아웃을 진행하기 때문에 이메일/비밀번호와 동일한 처리
5. 별도의 앱 화면 없이 비밀번호 변경
    - 파이어베이스 인증에서 제공하는 사용자 관리 메서드 사용
    - 소셜 로그인이 아닌 이메일/비밀번호로 로그인한 경우만 비밀번호 재설정 가능
        ```swift
        // 이메일/비밀번호로 로그인했는지 여부로 비밀번호 재설정 버튼을 보여줄지 결정
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        self.resetPasswordButton.isHidden = !isEmailSignIn
        ```
    - 현재 사용자의 이메일로 비밀번호를 재설정할 수 있는 메일 전송
        ```swift
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email)
        ```
6. **애플 로그인 구현** 
    - 애플 계정을 이용한 로그인을 제공하려면 **Apple Developer 프로그램에 가입**해야 함(유료, 연 구독)
    - 파이어베이스 콘솔 → Authentication 탭 → 로그인 메서드 → Apple 사용 설정
    - 프로젝트 설정 → TARGETS → + Capability → Sign in with Apple
    - Apple Developer 사이트에서 진행
        - 계정 로그인 → Certifications, Identifiers & Profiles → Identifier 추가 → Service IDs(App IDs와 별개로 애플 로그인과 같이 추가 서비스를 제공할 때 별도로 필요한 ID) 선택 → indentifier 입력(ex. ”앱 번들ID.signin”)
        - 추가된 identifier 선택 → Sign In with Apple 선택 → configure → OAuth를 사용하기 위해 승인된 도메인을 입력해야 하는데 파이어베이스에서 해당 도메인 제공 → 파이어베이스 Authentication 탭의 승인된 도메인(프로젝트 이름.firebaseapp.com)과 callback url 붙여 넣기
    - 애플에서 기본적으로 제공하는 `AuthenticationServices` 프레임워크 사용
        - ASAuthorizationController로 인증 정보를 전달해서 appleIDCredential을 받게 되면 idToken이 전달이 되고 토큰으로 Credential을 구성해서 파이어베이스에 전달하고 로그인
        - `Nonce` 란
            - 암호화된 임의의 난수로, 단 한번만 사용할 수 있는 값
            - 주로 암호화 통신을 할 때 활용 ex. 아이디/비밀번호를 전달하면서 인증 요청을 할 때 Nonce 값도 포함해서 전달하면 Nonce 값은 한번만 사용할 수 있기 때문에 응답도 한 번만 하고 임의의 난수여서 탈취하기 쉽지 않음
            - 동일한 요청을 짧은 시간에 여러 번 보내는 릴레이 공격 방지
            - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전 장치
            - 앱 → 애플 계정, 앱 → 파이어베이스로 안전하게 인증 정보를 전달
            - `Crypto` 프레임워크 사용
    - 애플 로그인은 시뮬레이션에서 동작 X
7. 로그인한 사용자의 Display Name을 업데이트
    - 애플 로그인은 사용자 개인 정보를 위해서 사용자가 이메일을 공유할 지 가릴 지를 선택할 수 있도록 하는데 가리는 옵션을 선택한 경우 애플은 사용자의 개인 이메일 주소를 숨기고 고유의 임의의 이메일 주소를 공유하게 됨 → 프로필에 임의의 이메일 대신 닉네임을 보여주는 것이 더 이상적
    - 프로필 정보 업데이트
        ```swift
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "토끼" // 바꿀 닉네임
        changeRequest?.commitChanges { _ in // 커밋을 해줘야 수정사항이 반영됨
            let displayName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "고객"
            
            self.welcomeLabel.text = """
                    환영합니다.
                    \(displayName)님
                """
        }
        ```
        - 사용자 프로필에는 display name 외에도 email, photo url, phone number 등 다양한 옵션을 제공하고 있어 파이어베이스 인증을 통해서 로그인하면 나만의 프로필 화면 구현 가능

