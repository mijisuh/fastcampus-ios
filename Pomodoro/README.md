# 🍅 뽀모도로 타이머 앱

> - DatePicker를 통해 타이머 시간을 설정할 수 있다.
> - 시작 버튼을 누르면 타이머가 시작되고 일시 정지를 누르면 타이머가 일시 정지된다.
> - 취소 버튼을 누르면 타이머가 종료된다.
> - 카운트 다운이 완료되면 알람이 울린다.

![Simulator Screen Recording - iPhone 14 - 2024-02-22 at 21 36 14](https://github.com/mijisuh/fastcampus-ios/assets/57468832/d8ab96b9-1761-48ab-8083-aaec10f65f33)

## 주요 개념 정리

<details>
<summary>DispatchSourceTimer</summary>

- 타이머란 <u>특정 시간이 지나고 이벤트를 발생</u>시키거나 <u>반복적인 주기로 특정 작업을 수행</u>하는 행위를 하는 것
- GCD API에 있는 `DispatchSourceTimer`를 이용해서 타이머 구현 가능
    - **GCD(Grand Central Dispatch)** 란 <u>작업을 병렬적으로 처리하기 위해 애플이 제공해주는 API</u>로, 스레드를 만들거나 관리해야 하는 경우 사용자는 그저 Task가 담긴 큐를 만들고 그 큐를 GCD에 던져버리면 GCP가 모든 스레드를 관리해줌
    - **Main Thread**: iOS에서 오직 한 개만 존재하는 스레드로 대부분의 코드는 메인 스레드로 작업 → 대부분의 클래스가 Cocoa 프레임워크로 정의되는데 Cocoa가 메인스레드에서 호출되기 때문
    - 메인 스레드를 인터페이스 스레드라고도 하는데 유저가 인터페이스에 접근하면 이벤트는 메인 스레드로 전달되기 때문에 <u>인터페이스 관련 코드(UI 관련 작업)는 메인 스레드 내에서 작성</u>되어야 함
- ex) 1초에 한번씩 타이머 핸들러를 호출시켜서 시간을 카운트 다운
</details>

<details>
<summary>UIView Animation</summary>

- UIView 클래스는 애니메이션에서 사용되는 API를 타입 메서드로 제공하고 이 메서드를 활용해서 비교적 단순한 코드로 애니메이션을 구현할 수 있음
- ex) alpha 값으로 뷰가 자연스럽게 사라지거나 생기도록 하는 애니메이션 구현, 이미지 뷰의 transform 값을 조정해서 회전되는 애니메이션 구현
</details>

## 구현 내용
1. ImageView, Label, ProgressView, DatePicker 추가
    - Assets에 Image Set 추가 후 ImageView에 이미지 설정
    - **프로그래스 뷰**는 <u>시간 경과에 따른 작업 진행 사항을 나타내는 뷰</u>
    - DatePicker의 `Preferred Style`은 `Wheels`, `Mode`는 `Count Down Time`로 설정
    - 라벨과 프로래스 뷰의 hidden 속성 체크 → DatePicker 설정이 끝나고 타이머가 시작될 때 보여지도록 구현
2. 타이머의 상태에 따라 화면 구성이 달라지게 구현
    - 타이머 상태를 저장할 열거형 타입 정의
        - 시작
        - 일시정지
        - 종료
    - 버튼의 상태에 따라 버튼의 title을 다르게 보여줌
        ```swift
        self.toggleButton.setTitle("시작", for: .normal) // 버튼의 상태가 normal이면(selected가 아니면)
        self.toggleButton.setTitle("일시정지", for: .selected) // 버튼의 상태가 selected이면
        ```
3. 시작 버튼 클릭 시 타이머 동작
    - 타이머 설정 및 시작
        ```swift
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main) // 어떤 스레드 큐에서 반복 동작할 것인지 설정
        self.timer?.schedule(deadline: .now(), repeating: 1) // 어떤 주기로 타이머를 실행할 것인지, 몇 초마다 반복되도록 할 것인지
        self.timer?.setEventHandler(handler: { [weak self] in // 타이머가 동작할 때마다 호출(1초에 한번씩 실행)
            self?.currentSeconds -= 1
            
            if self?.currentSeconds ?? 0 <= 0 {
                // 타이머 종료
            }
        })
        self.timer?.resume() // 타이머 시작
        ```
    - 타이머 종료
        ```swift
        if self.timerStatus == .pause { // 일시정지 상태(suspend)에서 nil을 대입하면 런타임 오류 발생
            self.timer?.resume()
        }
        
        self.timer?.cancel()
        self.timer = nil // 타이머 종료시 꼭 메모리 해제 필요
        ```
4. 카운드 다운되는 초를 라벨로 표시하고 프로그래스 뷰의 게이지도 줄여들도록 구현
    - 현재 카운트 다운되는 초를 시, 분, 초 형식으로 변환 후 적용
        ```swift
        let hours = self.currentSeconds / 3600
        let minutes = (self.currentSeconds % 3600) / 60
        let seconds = (self.currentSeconds % 3600) % 60
        
        self.timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds) // 서식자를 지정해서 두자릿수로 만들고 :(콜론)으로 구분
        self.pregressView.progress = Float(self.currentSeconds) / Float(self.duration)
        ```
5. 타이머가 종료되었을 때 알람 소리가 나도록 구현
    - `AudioToolbox` 이용
        ```swift
        import AudioToolbox
        AudioServicesPlaySystemSound(1005) // 시스템 사운드 ID 로 지정 가능
        ```
    - [어떤 시스템 사운드가 있는지 확인하는 사이트](http://iphonedev.wiki/AudioServices)
6. UIView Animation을 이용해 애니메이션 효과 구현
    - 데이트 피커 ↔ 라벨, 프로그래스 뷰의 전환이 자연스럽게 수정
        - Hidden 속성이 아닌 alpha 값을 조정
        - `UIView.animate()` 이용
            ```swift
            UIView.animate(withDuration: 0.5) { // 애니메이션을 몇 초동안 지속할 것인지
                self.timerLabel.alpha = 1
                self.pregressView.alpha = 1
                self.datePicker.alpha = 0
            } 
            ```
    - 타이머가 동작 중일 경우 이미지 뷰가 돌아가도록 수정
        - `UIView.animate()`, `CGAffineTransform` 이용
            ```swift
            UIView.animate(withDuration: 0.5, delay: 0) { // delay: 애니메이션을 몇 초뒤에 시작할 것인지 지정
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi) // 180도로 회전
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.5) { // 180도로 회전이 끝나면 동작하도록
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2) // 360도로 회전
            }
            ```
        - 타이머 동작이 끝나면 회전된 이미지를 원상 복구
            ```swift
            UIView.animate(withDuration: 0.5) {
                self.timerLabel.alpha = 0
                self.pregressView.alpha = 0
                self.datePicker.alpha = 1
                self.imageView.transform = .identity // 회전된 이미지를 원상태로 복구
            }
            ```
