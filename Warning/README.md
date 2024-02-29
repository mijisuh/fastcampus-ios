# 🚨 재난문자 푸시 알림 앱

> - 특정 사용자 혹은 전체 사용자에게 원격 알림을 전송할 수 있음

## 주요 개념 정리

<details>
<summary>Remote Notification</summary>

## Remote Notification

<img width="980" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/63d016ee-7cf2-4688-ac73-1a18c7162d91">

- 알림의 내용과 시점을 로컬 기기 자체만으로 알 수 없고 예측을 할 수 없기 때문에 미리 코드로 static하게 작성한 문구를 사용할 수 없는 경우 사용
- **서비스의 서버, 백엔드 영역에서 특정 시점에 알림 발송 가능**
- 원격 알림 전송 방식
    
    <img width="974" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/9adacb67-7a11-42ed-a71c-429a527cb759">
    
    - Provider: 원격 알림을 보낼 자체 서버
</details>

<details>
<summary>APNs</summary>

## APNs

- **A**pple **P**ush **N**otification **S**ervice
- **서버에서 알림을 바로 기기로 보내지 않고 APNs를 거쳐야 함**
- **알림 관리**
    - APNs에는 저장 후에 전달 기능을 수행하는 qos 구성요소가 포함되어 있음 → **각 기기의 상태를 확인**하여 **상태에 따라 알림을 저장 후에 전달**하고 **최신 알림을 관리**하는 등의 관리 센터의 역할을 함
    - 먼저 APNs가 알림 전달을 시도하고 알림을 받은 **대상기기가 오프라인인 경우 APNs는 제한된 시간동안 알림을 저장**하고 **장치가 다시 사용 가능한 온라인 상태가 되면 전달**
    - **APNs는 기기 및 앱 별로 가장 최근의 알림만 저장** → 장치가 오프라인인 경우에 해당 장치를 대상하는 알림 요청을 보내면 이전에 가지고 있던 요청은 삭제되고 가장 최근의 알림만 저장, 전달
    - 각 앱 서비스의 Provier가 보내는 알림을 최신 상태로 하나씩 저장하다가 **장치가 오랫동안 오프라인 상태를 유지하면 저장된 모든 알림을 삭제**하는 식으로 관리
- **보안 관리**
    - 네트워크를 통해 전달되는 데이터의 경우 보안 문제가 중요 → 특정 사용자에게 보낸 데이터가 제 3자에 의해 탈취되어 데이터가 노출될 수도 있고 데이터가 오염되어 사용자에게 전달될 수도 있음
    - **APNs는 자체 보안 아키텍쳐를 통해서 원격 알림을 안전하게 제어**
        
        <img width="865" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/d4620021-d8b9-4797-9345-3f73cf5085ae">
        
    - 2가지의 신뢰 수준 사용
        - **Connection Trust(연결 신뢰)**
            1. Provider-to-APNs: **애플과 계약을 맺은 회사가 소유한 승인된 공급자만** APNs와 연결해서 알림 전송 가능(token-based(valid authentication key certificate), certificate-based(SSL certificate))
            2. APNs-to-Device: **승인된 장치만** APNs에 연결해서 알림 수신 가능
        - **Device Token Trust**
            - 각 원격 알림에서 End-to-End로 작동, 즉 알림이 올바른 제공자(시작)와 장치(끝)의 2가지 지점 사이에서만 라우팅되도록 하는 것
            - **Device Token**은 **애플이 특정 디바이스의 특정 앱에 할당한 고유 식별자를 포함하는** `NSData` **인스턴스**로, 누군가 탈취하더라도 내용을 알 수가 없음 → **오직 APNs만 디바이스 토큰의 내용을 읽고 해독할 수 있음**
                
                <img width="846" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e366b439-9772-40f4-9493-d03c5dd29914">
                
            - (1)  각 앱은 원격 알림을 사용하기 위해서 APNs에 등록 → (2) APNs로부터 고유한 디바이스 토큰을 받게 됨 → (3) 해당 Provider에게 토큰 전달 → (4) Provider는 알림 요청에 토큰을 추가하여 APNs에게 전달 → (5) APNs는 토큰이 포함된 요청을 받고 토큰을 통해서 푸쉬 알림이 고유한 디바이스 앱 조합에만 전달되도록 조정 가능
                
                <img width="874" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/cecac984-a8ee-492e-a85e-298b0a7b1027">
                
            - 디바이스 토큰을 여러 상황에서 **재발급 가능**: 새 기기에 앱 설치, 백업으로 기기 복원, 운영체제 재설치 등 디바이스와 앱의 상태가 변경되었을 경우 새로 발급해서 항상 고유한 상태가 되도록 함
</details>

<details>
<summary>Firebase Cloud Messaging</summary>

## Firebase Cloud Messaging

<img width="874" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ef89ef6a-b055-40ad-959e-05edcac973f5">

- APNs의 보안 요건을 갖춘 **서버를 직접 구축하기 힘들 때 손쉽게 원격 알림을 보낼 수 있도록** 도와주는 도구
- Provider의 역할을 FCM이 대신 해줌
- A/B Testing과 더불어서 특정 사용자를 타겟팅하여 메시지를 전송하고자 할 때 별도의 서버 개발이나 공수없이 바로 이용할 수 있다는 장점이 있음
- 주요 기능
    - **원격 알림 메시지 전송**: 사용자에게 표시되는 알림 메시지를 실시간 또는 예약 전송
    - **다양한 메시지 타겟팅**: 단일 기기, 기기 그룹, 주제를 구독한 기기
    - **발송 메시지 저장, 관리**: 알림 내용, 상태, 플랫폼, 최종 전송 시간, 열람률 관리
- **웹 콘솔** 활용
    - 원격 알림 구성 내용을 직접 입력
</details>

## 전체 화면 구성
- 원격으로 알림 메세지를 구성해서 전송하고 앱에서는 발송된 원격 알림을 받아서 표현

    <img width="410" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2ad7b948-770c-4d2a-9e58-6c0712602728">

## 구현 내용
1. 파이어베이스 콘솔 작업
    - 프로젝트 생성
    - iOS 어플리케이션 추가
2. Xcode 프로젝트 작업
    - 구성 파일 xcode 프로젝트에 추가
    - pod 설치 → `pod 'Firebase/Analytics'`, `pod 'Firebase/Messaging'`
    - 파이어베이스 초기화
3. APNs 구성하기
    - **Apple Developer 멤버십 유료 구독 필수**
    - 프로젝트 설정 → Signing & Capabilities → + Capability → Push Notifications 선택을 하면 프로필을 만들고 certificate가 생성됨
    - Apple Developer → Certificates, Identifiers & Profiles → Keys → Key Name 이름 입력, Apple Push Notifications service 체크 → Register → Key ID 복사 및 다운로드
    - 파이어베이스 프로젝트 → 프로젝트 설정 → 클라우드 메시징 → iOS 앱 구성 → APN 인증 키 업로드 → 다운로드 했던 Key 파일 업로드, Key ID 및 팀 이름 입력
4. 원격 알림을 받을 수 있도록 User Notifications 설정
    - `AppDelegate`에 구현
        ```swift
        import UIKit
        import Firebase
        import UserNotifications
        
        @main
        class AppDelegate: UIResponder, UIApplicationDelegate {
        
            func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
                UNUserNotificationCenter.current().delegate = self
                return true
            }
        
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                FirebaseApp.configure()
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
                    print("ERROR Request Notifications Authorization: \(error.debugDescription)")
                }
                
                application.registerForRemoteNotifications()
                
                return true
            }
        		...
        
        }
        
        extension AppDelegate: UNUserNotificationCenterDelegate {
            
            // 원격 알림의 디스플레이 형태 지정
            func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                completionHandler([.list, .banner, .badge, .sound])
            }
            
        } 
        ```
5. FCM 설정 및 원격 알림 전송 
    - FCM SDK는 앱을 시작할 때 혹은 토큰이 업데이트 되거나 무효화 될 때마다 **클라이언트 앱 인스턴트 용 등록 토큰 생성** → 이런 자체 토큰을 통해 **타겟팅한 알림을 앱의 특정 인스턴스로 전송 가능**
    - `FIRMessagingDelegate` 메서드를 통해 등록 토큰 및 갱신 시점을 알 수 있음
        ```swift
        import FirebaseMessaging
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
            
            Messaging.messaging().delegate = self
            
            // FCM 현재 등록 토큰 확인
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("ERROR FCM 등록토큰 가져오기: \(error.localizedDescription)")
                } else if let token = token {
                    print("FCM 등록토큰: \(token)")
                }
            }
            
            ...
            
            return true
        }
        ```
        ```swift
        extension AppDelegate: MessagingDelegate {
            
            func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
                guard let token = fcmToken else { return }
                print("FCM 등록토큰 갱신: \(token)")
            }
            
        }
        ```
        - **시뮬레이터에서 테스트 불가**
        - 콘솔에 표시된 등록토큰 복사
    - 파이어베이스 콘솔 → 참여 → Cloud Messaging → 알림 작성 → 알림 제목, 텍스트 입력 → 테스트 메시지 전송 → FCM 등록토큰 입력 → 기기에서 테스트
6. 해당 앱을 사용하는 전체 사용자에게 메시지 전송
    - 파이어베이스 콘솔 → 참여 → Cloud Messaging → 알림 작성 → 알림 제목, 텍스트 입력 → 다음 → 타겟 설정(앱 선택) → 예약(발송 시점) 설정 → 추가 옵션(알림음, 뱃지 등) → 검토 → 게시
    - 앱 클릭 시 뱃지가 사라지도록 `SceneDelegate`에 코드 작성
        ```swift
        func sceneDidBecomeActive(_ scene: UIScene) {
            if UIApplication.shared.applicationIconBadgeNumber != 0 {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
        ```
