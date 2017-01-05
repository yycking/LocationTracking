//
//  LogCenter.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import CoreData
import CoreLocation

class LogCenter: NSManagedObjectContext {
    static let entityName = "LocationPoint"
    static let current: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "LocationTracking")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    static func add(location: CLLocation?) {
        guard let data = NSEntityDescription.insertNewObject(forEntityName: entityName, into: current) as? LocationPoint else { return }
        var value = CLLocation()
        if let loc = location {
            value = loc
        }
        
        data.initFromLocation(location: value)
    }
    
    static func loadData() -> [CLLocation] {
        let request = NSFetchRequest<LocationPoint>(entityName: entityName)
        
        var loactions = [CLLocation]()
        
        guard let results = try? current.fetch(request) else {
            return loactions
        }
        for result in results {
            loactions.append(result.location())
        }
        
        return loactions
    }
    
    static func delData() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        let _ = try? current.execute(request)
    }
    
    static func saveContext () {
        if current.hasChanges {
            try? current.save()
        }
    }
}
