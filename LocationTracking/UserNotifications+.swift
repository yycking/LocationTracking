//
//  UserNotifications+.swift
//  LocationTracking
//
//  Created by YehYungCheng on 2017/2/1.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter {
    static func request(options: UNAuthorizationOptions) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    static func title(_ title: String) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = title
        return content
    }
    
    static func subtitle(_ subtitle: String) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.subtitle = subtitle
        return content
    }
    
    static func body(_ body: String) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.body = body
        return content
    }
}

extension UNMutableNotificationContent {
    func title(_ title: String) -> UNMutableNotificationContent{
        self.title = title
        return self
    }
    
    func subtitle(_ subtitle: String) -> UNMutableNotificationContent{
        self.subtitle = subtitle
        return self
    }
    
    func body(_ body: String) -> UNMutableNotificationContent{
        self.body = body
        return self
    }
    
    func post() {
        let idKey = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let request = UNNotificationRequest(identifier: idKey, content: self, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
