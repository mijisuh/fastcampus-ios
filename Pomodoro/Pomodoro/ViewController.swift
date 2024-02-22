//
//  ViewController.swift
//  Pomodoro
//
//  Created by mijisuh on 2024/02/22.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pregressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var duration = 60 // 타이머에 저장된 시간을 초로 저장 -> DatePicker의 dafault 값이 1분이어서
    
    var timerStatus: TimerStatus = .end // 타이머의 상태
    
    var timer: DispatchSourceTimer?
    
    var currentSeconds = 0 // 현재 카운트다운되고 있는 초
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    private func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.pregressView.isHidden = isHidden
    }
    
    private func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal) // 버튼의 상태가 normal이면
        self.toggleButton.setTitle("일시정지", for: .selected) // 버튼의 상태가 selected이면
    }
    
    private func startTimer() {
        // 타이머 생성
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main) // 어떤 스레드 큐에서 반복 동작할 것인지 설정
        
        if let _ = self.timer {
            //  타이머 설정
            self.timer?.schedule(deadline: .now(), repeating: 1) // 어떤 주기로 타이머를 실행할 것인지, 몇 초마다 반복되도록 할 것인지
            self.timer?.setEventHandler(handler: { [weak self] in // 타이머가 동작할 때마다 호출(1초에 한번씩 실행)
                guard let self = self else { return } // 일시적으로 self가 강한 참조가 되도록 함
                self.currentSeconds -= 1
                
                let hours = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds) // 서식자를 지정해서 두자릿수로 만들고 :(콜론)으로 구분
                self.pregressView.progress = Float(self.currentSeconds) / Float(self.duration)
                
                UIView.animate(withDuration: 0.5, delay: 0) { // delay: 애니메이션을 몇 초뒤에 시작할 것인지 지정
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi) // 180도로 회전
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.5) { // 180도로 회전이 끝나면 동작하도록
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2) // 360도로 회전
                }
                
                if self.currentSeconds <= 0 {
                    // 타이머 종료
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume() // 타이머 시작
        }
    }
    
    private func stopTimer() {
        if self.timerStatus == .pause { // 일시정지 상태(suspend)에서 nil을 대입하면 런타임 오류 발생
            self.timer?.resume()
        }
        
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.timerLabel.alpha = 0
            self.pregressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity // 회전된 이미지를 원상태로 복구
        }
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil // 타이머 종료시 꼭 메모리 해제 필요
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {  // 타이머 종료
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
        default: break
        }
    }
    
    @IBAction func tabToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration) // DatePicker에서 선택한 시간이 몇 초인지 알려줌
        switch self.timerStatus {
        case .start: // 시작 -> 일시정지
            self.timerStatus = .pause
            self.toggleButton.isSelected = false // "일시정지" -> "시작"
            self.timer?.suspend()
            
        case .pause: // 일시정지 -> 시작
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
            
        case .end: // -> 시작
            self.currentSeconds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5) { // 애니메이션을 몇 초동안 지속할 것인지
                self.timerLabel.alpha = 1
                self.pregressView.alpha = 1
                self.datePicker.alpha = 0
            }
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true // "시작" -> "일시정지"
            self.startTimer()
        }
    }
    
}

