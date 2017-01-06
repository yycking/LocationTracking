//
//  LocationCenter.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import CoreLocation

class LocationCenter: CLLocationManager {
    static let this : LocationCenter = {
        let instance = LocationCenter()
        instance.requestAlwaysAuthorization()
        instance.reloadSetting()
        instance.delegate = instance
        return instance
    }()
    var enableSignificantLocationChanges = false
    var enableRegion = false
    
    func registerNextRegion() {
        guard let location = self.location else { return }
        let region = CLCircularRegion(center: location.coordinate, radius: self.distanceFilter, identifier: "")
        self.startMonitoring(for: region)
    }
    
    static func start() {
        this.startUpdatingLocation()
        
        if this.enableSignificantLocationChanges {
            this.startMonitoringSignificantLocationChanges()
        }
        
        if this.enableRegion {
            this.registerNextRegion()
        }
    }
    
    static func stop() {
        this.stopUpdatingLocation()
        this.stopMonitoringSignificantLocationChanges()
        this.stopRegions()
    }
    
    func stopRegions() {
        for region in self.monitoredRegions {
            self.stopMonitoring(for: region)
        }
    }
    
    func reloadSetting() {
        let defaults = UserDefaults.standard
        
        var activityType:CLActivityType  = .other
        if let type = defaults.string(forKey: "activityType") {
            switch type {
            case "automotiveNavigation":
                activityType = .automotiveNavigation
            case "fitness":
                activityType = .fitness
            case "otherNavigation":
                activityType = .otherNavigation
            //case "other",
            default:
                activityType = .other
            }
        }
        self.activityType = activityType
        
        self.distanceFilter = loadDouble(forKey: "distanceFilter", defaultValue: kCLDistanceFilterNone)
        
        var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
        if let type = defaults.string(forKey: "desiredAccuracy") {
            switch type {
            case "bestForNavigation":
                desiredAccuracy = kCLLocationAccuracyBestForNavigation
            case "nearestTenMeters":
                desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            case "hundredMeters":
                desiredAccuracy = kCLLocationAccuracyHundredMeters
            case "kilometer":
                desiredAccuracy = kCLLocationAccuracyKilometer
            case "threeKilometers":
                desiredAccuracy = kCLLocationAccuracyThreeKilometers
            //case "best",
            default:
                desiredAccuracy = kCLLocationAccuracyBest
            }
        }
        self.desiredAccuracy = desiredAccuracy
        
        self.pausesLocationUpdatesAutomatically = loadBool(forKey: "pausesLocationUpdatesAutomatically", defaultValue: true)
        self.allowsBackgroundLocationUpdates = loadBool(forKey: "allowsBackgroundLocationUpdates")
        
        enableSignificantLocationChanges = loadBool(forKey: "significantLocationChanges")
        if enableSignificantLocationChanges == false {
            self.stopMonitoringSignificantLocationChanges()
        }
        
        enableRegion = loadBool(forKey: "region")
        if enableRegion == false {
            self.stopRegions()
        }
    }
    
    static func reloadSetting() {
        this.reloadSetting()
    }
}

func loadDouble(forKey key: String, defaultValue: Double) -> Double {
    let defaults = UserDefaults.standard
    if let _ = defaults.object(forKey: key) {
        return defaults.double(forKey: key)
    }
    return defaultValue;
}

func loadBool(forKey key: String, defaultValue: Bool = false) -> Bool {
    let defaults = UserDefaults.standard
    if let _ = defaults.object(forKey: key) {
        return defaults.bool(forKey: key)
    }
    return defaultValue;
}

extension LocationCenter: CLLocationManagerDelegate {
    func post(location: CLLocation?, type: LocationType) {
        let location = location ?? CLLocation()
        LogCenter.add(location: location, type: type)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        post(location: locations.last, type: .Update)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopMonitoring(for: region)
        
        post(location: manager.location, type: .LeaveRegion)
        guard let center = manager as? LocationCenter else { return }
        center.registerNextRegion()
    }
}

