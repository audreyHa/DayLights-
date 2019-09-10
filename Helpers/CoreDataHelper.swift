//
//  CoreDataHelper.swift
//  DayLights
//
//  Created by Audrey Ha on 3/25/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper{
    static let context: NSManagedObjectContext={
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else{
            fatalError()
        }
        let persistentContainer=appDelegate.persistentContainer
        let context=persistentContainer.viewContext
        return context
    }()
    
    lazy var persistentContainer: NSPersistentContainer={
        let container=NSPersistentContainer(name: "Daylight")
        
        let description=NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically=true
        description.shouldInferMappingModelAutomatically=true
        container.persistentStoreDescriptions=[description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error=error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func newDaylight()->Daylight{
        let daylight=NSEntityDescription.insertNewObject(forEntityName: "Daylight", into: context) as! Daylight
        return daylight
    }
    
    static func newOrg() -> Organization{
        let organization=NSEntityDescription.insertNewObject(forEntityName: "Organization", into: context) as! Organization
        return organization
    }
    
    static func newNotiTime() -> NotificationTime{
        let notiTime=NSEntityDescription.insertNewObject(forEntityName: "NotificationTime", into: context) as! NotificationTime
        return notiTime
    }

    
    static func newDrawing()->Drawing{
        let drawing=NSEntityDescription.insertNewObject(forEntityName: "Drawing", into: context) as! Drawing
        return drawing
    }
    
    static func newQuote()->Quote{
        let quote=NSEntityDescription.insertNewObject(forEntityName: "Quote", into: context) as! Quote
        return quote
    }
    
    static func saveDaylight(){
        do{
            try context.save()
        }catch let error{
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(daylight: Daylight){
        context.delete(daylight)
        saveDaylight()
    }

    static func delete(noti: NotificationTime){
        context.delete(noti)
        saveDaylight()
    }
    
    static func delete(drawing: Drawing){
        context.delete(drawing)
        saveDaylight()
    }
    
    static func delete(quote: Quote){
        context.delete(quote)
        saveDaylight()
    }
    
    static func retrieveDaylight()->[Daylight]{
        do{
            let fetchRequest=NSFetchRequest<Daylight>(entityName: "Daylight")
            let results=try context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    static func retrieveDrawing()->[Drawing]{
        do{
            let fetchRequest=NSFetchRequest<Drawing>(entityName: "Drawing")
            let results=try context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    static func retrieveOrg()->[Organization]{
        do{
            let fetchRequest=NSFetchRequest<Organization>(entityName: "Organization")
            let results=try context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    static func retrieveNotification()->[NotificationTime]{
        do{
            let fetchRequest=NSFetchRequest<NotificationTime>(entityName: "NotificationTime")
            let results=try context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    static func retrieveQuote()->[Quote]{
        do{
            let fetchRequest=NSFetchRequest<Quote>(entityName: "Quote")
            let results=try context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }

    
}
