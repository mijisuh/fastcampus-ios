//
//  UNNotificationCenter.swift
//  Drink
//
//  Created by mijisuh on 2024/02/28.
//

import Foundation
import UserNotifications

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
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        // Request
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        self.add(request)
    }
    
}
