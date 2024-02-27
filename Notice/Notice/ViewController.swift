//
//  ViewController.swift
//  Notice
//
//  Created by mijisuh on 2024/02/27.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getNotice()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureRemoteCofig()
    }
    
    private func configureRemoteCofig() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0 // 테스트를 위해 새로운 값을 패치하는 인터벌을 최소화해서 최대한 자주 원격 구성에 있는 데이터를 가져옴
        self.remoteConfig?.configSettings = setting
        
        self.remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }

}

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
            if !self.isNoticeHidden(remoteConfig) {
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n") // 여러 줄 받아올 때 \n에서 \이 2번 찍혀서 swift에서 줄바꿈을 인식하지 못해 추가적인 처리 필요
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContents = (title: title, detail: detail, date: date)
                self.present(noticeVC, animated: true)
            } else {
                self.showEventAlert()
            }
        }
    }
    
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        return remoteConfig["isHidden"].boolValue
    }
    
}

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
