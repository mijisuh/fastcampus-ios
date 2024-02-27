# 📢 실시간 공지사항 팝업 앱

> - 전체 사용자를 반으로 나눠 무작위로 A안 또는 B안을 보여줌
> - 사용자가 쓰는 언어, 기기 등으로 사용자 타켓팅을 하여 A안 또는 B안을 보여줌
> - 심사없이 내용을 업데이트할 수 있고 상황에 따라 보여지거나 숨길 수 있는 공지사항 팝업을 만듬

## 주요 개념 정리

<details>
<summary>Firebase - Remote Config</summary>

## Remote Config

- 개발자가 배포하거나 사용자가 앱 업데이트를 다운로드 할 필요 없이 앱의 동작과 모양을 변경할 수 있는 클라우드 서비스
- 앱의 동작과 모양을 정의하는 기본 값 설정 후 값을 재정의해서 앱에 반영
- 클라우드 기반 **key-value** 저장소
- 주요 기능
    - **앱 사용자 층에 변경 사항을 빠르게 적용**
        - 업데이트 없이 앱의 UI/UX 변경 지원
    - **사용자 층의 특정 세그먼트에 앱 맞춤 설정**
        - 앱 버전, 언어, 위치 등으로 분류된 사용자 세그먼트 별 환경 제공
    - **A/B 테스트를 실행하여 앱 개선**
        - 사용자 세그먼트 별로 개선 사항을 검증 후 점진적 적용
</details>

<details>
<summary>Firebase - A/B Testing</summary>

## A/B Testing

- 어떤 것이 최적의 제품 환경인지를 테스팅하는 것
- Google Analytics, Firebase 예측을 통한 사용자 타겟팅
- 테스팅 방법은 원격 구성(Remote Cofig 또는 알림작성기(Cloud Messaging) 활용
- 제품, 마케팅 실험을 쉽게 실행, 분석, 확장
- 주요 기능
    - **제품 환경 테스트 및 개선**
        - 앱 동작 및 모양을 변경하여 최적의 제품 환경 확인
    - **사용자의 재참여를 유도할 방안 모색**
        - 앱 사용자를 늘리기에 가장 효과적인 문구와 메시징 설정
    - **새로운 기능의 안전한 구현**
        - 작은 규모의 사용자 집합을 대상으로 원하는 목표를 달성할 수 있는지 확인
    - **‘예측된’ 사용자 그룹 타켓팅**
        - 특정 행동을 할 것으로 예측된 사용자에 A/B 테스트 실시
</details>

## 전체 화면 구성

<img width="968" alt="0" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/6e3d065a-b5d5-40cf-9fc4-d9982efd7c36">

- MainViewController 

    <img width="798" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/668600a8-555a-454b-a328-5df24843d314">
    
- NoticeViewController

    <img width="766" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ce716d68-5fec-412f-b890-264f91c458fd">

    - MainViewController 위에 띄울 공지 사항 팝업
    - Remote Config를 통해 보여질 수도 있고 가려질 수도 있음
    - Remote Cofig를 통해 팝업에 포함된 각각의 문자열들을 변경할 수 있도록 설정

        <img width="1004" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/144fc6e2-ce7c-4c96-a4f6-ef445b086365">

    - 이벤트 알림 문구를 A안, B안으로 나눠 Remote Config을 활용한 A/B Testing으로 구현 → 사용자를 반으로 나눠 각각 보여줄 수 있음

        <img width="703" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/d69ca16d-9d1b-4a0c-bd4f-4b01baea6f24">


## 구현 내용
1. **UI 구성**
    - NoticeViewController 생성
        - nib 파일로 화면 구성
        - Remote Config로 내용을 업데이트 할 라벨들을 아울렛 변수로 정의
2. **파이어베이스 연결**
    - 콘솔 작업
    - 코코아팟 설치 - `pod 'Firebase/RemoteConfig'`, `pod 'Firebase/Analytics'`
    - Xcode 작업
        - 프로젝트에 구글 설정 파일 추가
        - 파이어베이스 초기화 작업
3. **Remote Config로 팝업 제어하기**
    - RemoteConfig 객체 생성
        
        ```swift
        import FirebaseRemoteConfig
        
        var remoteConfig: RemoteConfig?
        ```
        
    - RemoteConfig setting 값 설정
        
        ```swift
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0 // 테스트를 위해 새로운 값을 패치하는 인터벌을 최소화해서 최대한 자주 원격 구성에 있는 데이터를 가져옴
        self.remoteConfig?.configSettings = setting
        ```
        
    - Plist 파일 생성
        - 원격 구성은 key-value의 Dictionary 형태
        - `isHidden`: NoticeViewController를 숨길 것인지의 설정 값
        - `title`
        - `detail`
        - `date`
    - Remote Config가 인식할 수 있도록 연결
        
        ```swift
        self.remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults") // 생성한 plist의 이름
        ```
        
    - 파이어베이스 콘솔에서 프로젝트 → 참여 → RemoteConfig → 구성 만들기
        - plist에서 만들었던 것처럼 매개변수 만들기
    - 콘솔에 설정한 값들을 패칭
        
        ```swift
        // RemoteConfig
        extension ViewController {
            
            func getNotice() {
                guard let remoteConfig = self.remoteConfig else { return }
                
                remoteConfig.fetch { [weak self] status, _ in
                    if status == .success {
                        remoteConfig.activate()
                    } else {
                        print("ERROR: Config not fetched")
                    }
                    
                    guard let self = self else { return }
                    if self.isNoticeHidden(remoteConfig) {
                        let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                        noticeVC.modalPresentationStyle = .custom
                        noticeVC.modalTransitionStyle = .crossDissolve
                        
                        let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n") // 여러 줄 받아올 때 \n에서 \이 2번 찍혀서 swift에서 줄바꿈을 인식하지 못해 추가적인 처리 필요
                        let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                        let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                        
                        noticeVC.noticeContents = (title: title, detail: detail, date: date)
                        self.present(noticeVC, animated: true)
                    }
                }
            }
            
            func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
                return remoteConfig["isHidden"].boolValue
            }
            
        }
        ```
        
    - 원격 구성 값 업데이트 후 화면 변경 확인
        - 파이어베이스 콘솔에서 값 변경
        - 우측 상단에 있는 ‘변경 사항 게시’ 클릭
        - UI 수정: 값이 변경되는 라벨의 Autoshrink를 Minimum Font Size로 변경해서 글자 수에 따라 라벨의 크기 조정
    - 조건에 따라 값이 다르게 보여지도록 설정
        - 파이어베이스 Remote Config에서 titlt 매개변수 수정 → 새로 추가 → 조건부 값 → 새 조건 만들기
        - 이름: english, 적용 조건: 언어, 영어로 설정
        - 사용자의 기기 설정이 영어로 되어 있다면 다른 값을 줄 수 있음
4. **A/B Testing으로 팝업 제어하기**
    - 파이어베이스 콘솔 → 프로젝트 → 참여 → A/B Testing → 실험 만들기 → 원격 구성
        - 기본사항
        - 타겟팅: 어떤 사용자 군을 타켓팅할 것인지 설정
        - 목표: 얼마나 꾸준히 들어오는지, 수익률은 어떤지 확인 가능 → 확인하기 버튼을 언제 더 많이 누르는지 확인하기 위해 새로운 이벤트 생성
        - 변형: 어떤 값과 어떤 값을 비교할 지 기준 값과 비교 값 설정
            - message 매개변수 생성
            - 기준 값: 이벤트에 참여하면 엄청난 행운이 찾아와요.
            - 비교 값: 이벤트에 참여하면 스타벅스 아메라카노 1잔이 무료!
        - 검토 버튼 클릭
        - 실험 시작 버튼 클릭 → Remote Config로 이동하면 message 확인 가능
    - Xcode에서 코드로 작업
        - 이벤트 alert의 confirm 버튼을 누를 때마다 Google Analytics로 이벤트 로깅
            
            ```swift
            // A/B Testing
            extension ViewController {
                
                func showEventAlert() {
                    guard let remoteConfig = self.remoteConfig else { return }
                    remoteConfig.fetch { [weak self] status, _ in
                        if status == .success {
                            remoteConfig.activate()
                        } else {
                            print("ERROR: Config not fetched")
                        }
                        
                        let message = remoteConfig["message"].stringValue ?? ""
                        let confirmActioon = UIAlertAction(title: "확인하기", style: .default) {_ in
                            // Google Analytics로 이벤트 로깅
                            Analytics.logEvent("promotion_alert", parameters: nil)
                        }
                        
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                        let alertController = UIAlertController(title: "깜짝 이벤트", message: message, preferredStyle: .alert)
                        
                        alertController.addAction(confirmActioon)
                        alertController.addAction(cancelAction)
                        
                        self?.present(alertController, animated: true)
                    }
                }
                
            }
            ```
            
        - Xcode → Product → Scheme → Edit Scheme → Run → Arguments Passed On Launch → ‘-FIRDebugEnabled’ 추가
    - Notice 팝업을 띄우지 않을 때 이벤트 alert를 보여주기 위해 Remote Config 콘솔에서 isHidden을 false로 설정
    - 파이어베이스 콘솔 → 프로젝트 → 애널리틱스 → DebugView
        - 디버그 기기: 현재 디버그 모드로 들어와 있는 시뮬레이터를 의미
        - 시뮬레이터에서 확인하기 버튼 클릭 시 promotion_alert 이벤트가 발생한 것을 확인 가능
    - 정말 사용자의 50% 마다 다른 값을 보여주는 지 확인
        - AppDelegate
            
            ```swift
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                // Override point for customization after application launch.
                FirebaseApp.configure()
                
                Installations.installations().authTokenForcingRefresh(true) { result, error in
                    if let error = error {
                        print("ERROR")
                        return
                    }
                    
                    guard let result = result else { return }
                    print("Installation auth token: \(result.authToken)") // 파이어베이스가 각각의 기기에 부여한 고유한 인증 토큰 값 확인
                }
                
                return true
            }
            ```
            
        - 콘솔에서 확인한 토큰 값 복사
        - 파이어베이스 A/B Testing → 실험 개요 → 점 3개 → 테스트 기기 관리 → 토큰 값 입력 → 기준 값을 보여줄지 비교 값을 보여줄 지 선택 → 추가

