//
//  AppDelegate.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let UpdateDataTable = "UpdateData"

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalNotificationCenter.registry()
        
        LocationCenter.current.delegate = self
        if let location = launchOptions?[.location] as? CLLocation {
            post(location: location, label: "Wakeup")
            LocationCenter.current.start()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        LogCenter.saveContext()
    }

}

import CoreLocation

extension AppDelegate: CLLocationManagerDelegate {
    func post(location: CLLocation?, label: String) {
        var text = "no"
        if let data = location {
            text = String(format: "%f, %f", data.coordinate.latitude, data.coordinate.longitude)
        }
        LocalNotificationCenter.post(title: label, subtitle: text)
        LogCenter.add(location: location)
        
        NotificationCenter.default.post(name: Notification.Name(type(of: self).UpdateDataTable), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            post(location: nil, label: "Update")
            return
        }
        
        post(location: location, label: "Update")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopMonitoring(for: region)
        
        guard
            let location = manager.location,
            let center = manager as? LocationCenter
        else {
            post(location: nil, label: "Region")
            return
        }
        center.registerNextRegion(location: location)
        post(location: location, label: "Region")
    }
}

