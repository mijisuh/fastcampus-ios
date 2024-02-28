# 🚰 물 마시기 알람 앱

> - 시계 앱의 알람 기능과 유사하게 언제 물을 마실지 시간을 지정하면 해당 시간에 알림을 보낼 수 있음
> - 스위치로 추가한 알람을 끄고 킬 수 있음
> - 알림 센터 및 아이콘 뱃지 표시

![Simulator Screen Recording - iPhone 14 - 2024-02-28 at 18 57 05](https://github.com/mijisuh/fastcampus-ios/assets/57468832/e885b252-4391-46a1-b06b-4e56fe84709a)

<img width="889" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/a98c988e-b284-451c-aba4-dbfe1c919ab3">

## 주요 개념 정리

<details>
<summary>Local Notification</summary>

## Local Notification

- 알림, 소리, 뱃지 등으로 표현되는 **앱 내부에서 자체적으로 만든 특정 메세지를 전달하는 알람**
- 사용자의 관심을 끌어 앱 사용량을 늘리고 특정 행동 유도
- `UserNotifications` 프레임워크를 이용해서 구현
- 로컬 알림의 구성
    - `UNNotificationRequest` 작성
        - **identifier**: 각각의 요청을 구분할 수 있는 id(일반적으로 uuid 사용) ex. 각각의 알림을 구분해서 끄고 끌 수 있음
        - `UNMutableNotification**Content**`: 알림에 나타날 내용 정의(title, body, 알림 소리, 뱃지에 표시될 내용)
        - `UN**Calendar**Notfication**Trigger**`(ex. 알림), `UN**TimeInterval**Notification**Trigger**`(ex. 타이머), `UN**Location**Notification**Trigger**`(ex. 위치): 알림이 활성화되는 조건
    - `UNNotification**Request**`를 `UNNotification**Center**`에 추가해야 함 ex. 우체통
        <img width="485" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/7b5a535a-3585-4fdd-b190-f3f69fbfa7ec">
    - UNNotificationCenter에 쌓인 Request는 Trigger로 정의한 것처럼 적절한 순간에 알림 전송
        <img width="982" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/6ca4a9b7-3fcc-40dd-a8aa-051eab656935">
    - 알람을 구분하여 끄거나 킬 수 있고, 삭제도 가능
        <img width="884" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2ae9ea2a-e7fc-44a9-9df4-d7ba5e834ba7">
</details>

## 전체 화면 구성

<img width="782" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/baf7786e-e7ae-4aca-9fd9-584d8c36084e">

- UITableViewController를 루트로 하는 NavigationController
- 알람 목록을 보여주는 테이블 뷰
    - 각각의 셀은 nib으로 구성
- 알람 추가 뷰

## 구현 내용
1. UINavigationViewController 추가
2. UITableViewController 구현
    - UITableViewCell도 nib 파일로 구현
    - Cell Register
    - UITableView Datasource, Delegate
        - 섹션을 나눠서 헤더 표현 → `titleForHeaderInSection` 메서드
        - 셀 선언 후 셀 내부의 컴포넌트에 데이터 전달
3. 알람 정보를 담을 Alert 정의
    
    ```swift
    struct Alert: Codable {
        
        var id: String = UUID().uuidString
        let date: Date
        var isOn: Bool
        
        var time: String { // date 값을 바로 라벨에 뿌려줄 수 있도록 String으로 변환
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm"
            return timeFormatter.string(from: date)
        }
        
        var meridiem: String {
            let meridiemFormatter = DateFormatter()
            meridiemFormatter.dateFormat = "a" // 오전/오후
            meridiemFormatter.locale = Locale(identifier: "ko")
            return meridiemFormatter.string(from: date)
        }
        
    }
    ```
    
4. 알람 추가를 위한 UIViewController 정의
    - Navigation Bar, Bar Button Item 추가
    - DatePicker 추가
        - Preferred Style: inline
        - Mode: Time
        - Locale: Korean (South Korea)
    - 코드로 present 구현
5. 새로운 값 설정 후 부모 뷰에 전달
    - 클로저를 이용해 전달
        
        ```swift
        // 자식 뷰
        var pickedDate: ((_ date: Date) -> Void)?
        
        @IBAction func saveButtonTapped(_ sender: Any) {
            // 설정한 시간 값을 부모 뷰에 전달
            pickedDate?(datePicker.date) // 클로저 이용
            self.dismiss(animated: true)
        }
        ```
        
        ```swift
        // 부모 뷰
        @IBAction func addAlertButtonTapped(_ sender: Any) {
                guard let addAlertVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
                addAlertVC.pickedDate = { [weak self] date in
                    guard let self = self else { return }
                    
        						// 새로운 알림이 생성될 때마다 테이블 뷰 반영, UserDefaults 저장 작업 필요
                    let newAlert = Alert(date: date, isOn: true)
                    ...
                }
                self.present(addAlertVC, animated: true)
            }
        ```
        
    - 설정된 모든 값이 앱이 종료된 후에도 유지가 될 수 있도록 UserDefaults 저장
        
        ```swift
        var alertList = self.alertList()
        alertList.append(newAlert)
        alertList.sort { $0.date < $1.date } // 시간 순서대로 정렬
        
        self.alerts = alertList // 테이블 뷰가 바라보는 데이터에 업데이트
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
        ```
        
    - 테이블 뷰에 새로운 값 반영 - `self.tableView.reloadData()`
6. 알람 삭제
    - 삭제된 데이터를 UserDefaults에 저장 및 테이블 뷰 반영
        
        ```swift
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle {
            case .delete:
                // Notification 삭제 구현
                self.alerts.remove(at: indexPath.row)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts") // 삭제한 배열을 넣어줌
                self.tableView.reloadData()
            default: break
            }
        }
        ```
        
7. 스위치 온오프 변경 값 반영
    - 각각의 셀들이 가지고 있는 스위치의 상태를 구분하는 방법
        - `cellForRowAt` 함수에서 태그 값을 부여
            
            ```swift
            cell.alertSwitch.tag = indexPath.row
            ```
            
        - 스위치 변경 시 UserDefaults 값 변경
            
            ```swift
            @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
                guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
                      var alerts = try? PropertyListDecoder().decode([Alert].self, from: data)
                else { return }
                
                alerts[sender.tag].isOn = sender.isOn // 해당하는 스위치의 isOn 값을 변경한 값으로 변경
                UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
            }
            ```
            
8. Notification 설정
    - `AppDelegate`에 구현
        - NotificationCenter 추가 후 delegate 선언
            
            ```swift
            import NotificationCenter
            
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
                UNUserNotificationCenter.current().delegate = self
                
                return true
            }
            ```
            
        - delegate 구현
            
            ```swift
            extension AppDelegate: UNUserNotificationCenterDelegate {
                
                // 노티피케이션을 보내기 전에 어떤 핸들링을 할 것인지 설정
                func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                    completionHandler([.banner, .list, .badge, .sound]) // 알림에 표시할 항목 정의
                }
                
                func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                    completionHandler()
                }
                
            }
            ```
            
        - 사용자에게 알림 전송에 대한 승인 요청
            
            ```swift
            import UserNotifications
            
            var userNotificationCenter = UNUserNotificationCenter.current()
            
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
                UNUserNotificationCenter.current().delegate = self
                
                let authorizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound]) // 다음 항목들에 대해서 사용 허락을 구함
                userNotificationCenter.requestAuthorization(options: authorizationOptions) { _, error in
                    if let error = error {
                        print("ERROR: Notification authorization request \(error.localizedDescription)")
                    }
                }
                
                return true
            }
            ```
            
    - `UNUserNotificationCenter`의 extension으로 노티 생성을 위한 함수 정의
        
        ```swift
        extension UNUserNotificationCenter {
            
            func addNotificationRequest(by alert: Alert) {
                // Content
                let content = UNMutableNotificationContent()
                content.title = "물 마실 시간이예요! 💦"
                content.body = "세계보건기구(WHO)가 권장하는 하루 물 섭취량은 1.5~2L 입니다."
                content.sound = .default
                content.badge = 1
                
                // Trigger
                let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn) // 특정 시간에 발송해야 하기 때문에
                
                // Request
                let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
                self.add(request)
            }
            
        }
        ```
        
    - 뱃지 클릭 시 뱃지가 사라지도록 구현 → `SceneDelegate`
        
        ```swift
        func sceneDidBecomeActive(_ scene: UIScene) {
            // 사용자가 앱을 열어서 Scene이 Active 상태가 되었을 때 Notification의 Badge를 사라지게 함
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        ```
        
    - 노티 추가 - 새로운 알림을 추가하는 경우, 스위치를 킨 경우
        
        ```swift
        import UserNotifications
        
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        self.userNotificationCenter.addNotificationRequest(by: newAlert)
        ```
        
    - 노티 삭제 - 알림을 삭제하는 경우, 스위치를 끌 경우
        
        ```swift
        self.userNotificationCenter.removeDeliveredNotifications(withIdentifiers: alerts[sender.tag].id)
        ```

