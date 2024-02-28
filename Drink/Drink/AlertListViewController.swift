//
//  AlertListViewController.swift
//  Drink
//
//  Created by mijisuh on 2024/02/28.
//

import UIKit
import UserNotifications

class AlertListViewController: UITableViewController {
    
    var alerts: [Alert] = []
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alerts = self.alertList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    private func configureView() {
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
        self.tableView.sectionHeaderTopPadding = 50
    }
    
    @IBAction func addAlertButtonTapped(_ sender: Any) {
        guard let addAlertVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        addAlertVC.pickedDate = { [weak self] date in
            guard let self = self else { return }
            
            var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true)
            // 새로운 알림이 생성될 때마다 테이블 뷰 반영, UserDefaults 저장 작업 필요
            
            alertList.append(newAlert)
            alertList.sort { $0.date < $1.date } // 시간 순서대로 정렬
            
            self.alerts = alertList // 테이블 뷰가 바라보는 데이터에 업데이트
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            
            // 노티 추가
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            
            self.tableView.reloadData()
        }
        self.present(addAlertVC, animated: true)
    }
    
    func alertList() -> [Alert] {
        // Alert는 PropertyList 형태로 저장이 되는데 우리가 이해할 수 있는 객체로 디코딩 필요
        // UserDefaults는 우리가 임의로 만든 구조체를 이해하지 못하므로 JSON처럼 인코딩, 디코딩 작업이 필요
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data)
        else { return [] }
        return alerts
    }
    
}

// UITableView Datasource, Delegate
extension AlertListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🚰 물 마실 시간"
        default:
           return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AlertListCell") as? AlertListCell else { return UITableViewCell() }
        
        cell.alertSwitch.isOn = self.alerts[indexPath.row].isOn
        cell.timeLabel.text = self.alerts[indexPath.row].time
        cell.meridiemLabel.text = self.alerts[indexPath.row].meridiem
        cell.alertSwitch.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // Notification 삭제 구현
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [self.alerts[indexPath.row].id]) // center가 가지고 있는 request 중에서 해당하는 id를 가진 request만 삭제
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts") // 삭제한 배열을 넣어줌
            self.tableView.reloadData()
        default: break
        }
    }
    
}
