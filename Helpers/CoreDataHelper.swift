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
    
    static func newDaylight()->Daylight{
        let daylight=NSEntityDescription.insertNewObject(forEntityName: "Daylight", into: context) as! Daylight
        return daylight
    }
    
    static func newOrg() -> Organization{
        let organization=NSEntityDescription.insertNewObject(forEntityName: "Organization", into: context) as! Organization
        return organization
    }
    
    static func saveDaylight(){
        do{
            try context.save()
            print("it should be saving...")
        }catch let error{
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(daylight: Daylight){
        context.delete(daylight)
        saveDaylight()
    }
    
    static func retrieveDaylight()->[Daylight]{
        do{
            let fetchRequest=NSFetchRequest<Daylight>(entityName: "Daylight")
            let results=try context.fetch(fetchRequest)
            print("there should be results")
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
            print("there should be results")
            return results
        }catch let error{
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    
}
