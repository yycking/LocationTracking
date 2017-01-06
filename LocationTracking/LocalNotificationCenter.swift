//
//  LocalNotificationCenter.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UserNotifications

class LocalNotificationCenter: UNUserNotificationCenter {
    static func registry() {
        current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    static func post(content: UNMutableNotificationContent) {        
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: nil)
        current().add(request) { (error) in
            
        }
    }
}
