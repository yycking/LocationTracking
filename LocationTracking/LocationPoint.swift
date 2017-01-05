//
//  LocationPoint.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import CoreLocation

extension LocationPoint {
    func initFromLocation(location: CLLocation) {
        self.latitude           = location.coordinate.latitude
        self.longitude          = location.coordinate.longitude
        self.altitude           = location.altitude
        self.timestamp          = location.timestamp as NSDate?
        
        self.horizontalAccuracy = location.horizontalAccuracy > 0.0 ? location.horizontalAccuracy : 0.0
        self.verticalAccuracy   = location.verticalAccuracy > 0.0 ? location.verticalAccuracy : 0.0
        self.speed              = location.speed > 0.0 ? location.speed : 0.0
        self.course             = location.course > 0.0 ? location.course : 0.0
    }
    
    func location() -> CLLocation {
        return CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude),
            altitude: self.altitude,
            horizontalAccuracy: self.horizontalAccuracy,
            verticalAccuracy: self.verticalAccuracy,
            course: self.course,
            speed: self.speed,
            timestamp: self.timestamp as! Date
        )
    }
}
