//
//  LogCenter.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import CoreData
import CoreLocation
import UserNotifications

class LogCenter: NSManagedObjectContext {
    static let entityName = String(describing: LocationPoint.self)
    static let this: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "LocationTracking")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    static func add(location: CLLocation, type: LocationType) {
        guard let data = NSEntityDescription.insertNewObject(forEntityName: entityName, into: this) as? LocationPoint else { return }
        
        data.initFromLocation(location: location)
        data.type = type.rawValue
        data.create = NSDate()
        
        UNUserNotificationCenter
            .title(type.rawValue)
            .subtitle(location.coordinate.latitude.description)
            .body(location.description)
            .post()
        
        NotificationCenter.default.post(name: Notification.Name(ViewController.UpdateDataTable), object: location)
    }
    
    static func loadData() -> [(location:CLLocation, type:String, date:Date)] {
        let request = NSFetchRequest<LocationPoint>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "create", ascending: true)]
        var loactions = [(CLLocation, String, Date)]()
        
        guard let results = try? this.fetch(request) else {
            return loactions
        }
        for result in results {
            loactions.append((result.location(), result.type!, result.create as! Date))
        }
        
        return loactions
    }
    
    static func delData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.includesPropertyValues = false
        
        guard let results = (try? this.fetch(request)) as? [NSManagedObject] else {
            return
        }
        
        for result in results {
            this.delete(result)
        }
    }
    
    static func saveContext () {
        if this.hasChanges {
            try? this.save()
        }
    }
}
