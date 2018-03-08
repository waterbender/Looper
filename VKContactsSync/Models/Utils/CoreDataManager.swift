//
//  CoreDataManager.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataManager {
    func addClientInfoEntity(clientInfoPassed: Dictionary<String, Any>) {
        
        if let managedContext = mainManagedObjectContext() {
            
            let userId = clientInfoPassed["userID"] as? String
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ClientInfoObject")
            fetchRequest.predicate = NSPredicate(format: "userId = %@", userId!)

            // if is object stop
            var count = 0
            do {
                count = try managedContext.count(for: fetchRequest)
                if (count != 0) {
                    return
                }
            } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                    return
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "ClientInfoObject",
                                           in: managedContext)!
            let clientInfo = ClientInfoObject(entity: entity,
                                         insertInto: managedContext)
            clientInfo.userAccessToken = clientInfoPassed["userAccessToken"] as? String
            clientInfo.typeOfRequest = clientInfoPassed["typeOfRequest"] as? String
            clientInfo.userId = clientInfoPassed["userID"] as? String
            clientInfo.phoneNumber = clientInfoPassed["phone"] as? String
            clientInfo.userName = clientInfoPassed["userName"] as? String
            clientInfo.userLastName = clientInfoPassed["userLastName"] as? String
            clientInfo.dateOfBirth = clientInfoPassed["dateOfBirth"] as? NSDate
        }
    }
    
    func addUserInfoEntity(userInfoPassed: Dictionary<String, Any>) {
        
//        let managedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        managedContext.parent = mainManagedObjectContext()
//        let entity =
//            NSEntityDescription.entity(forEntityName: "UserData",
//                                       in: managedContext)!
//        let userData = UserDataObject(entity: entity,
//                                              insertInto: managedContext)
//
//
//        save(context: managedContext);
    }
    
    func checkExistanceOfType(type: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ClientInfoObject")
        fetchRequest.predicate = NSPredicate(format: "typeOfRequest = %@", type)
        
        if let managedContext = mainManagedObjectContext() {
            
            // if is object stop
            var count = 0
            do {
                count = try managedContext.count(for: fetchRequest)
                if (count != 0) {
                    return true
                }
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                return false
            }
        }
        
        return false
    }
    
    func getClientInfoObjectFor(type: String) -> [String:Any]? {
        
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "ClientInfoObject")
        let sortDescriptor = NSSortDescriptor(key: "typeOfRequest", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "typeOfRequest = %@", type)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedContext = mainManagedObjectContext() {
            
            // if is object stop
            do {
                
                let result = try managedContext.fetch(fetchRequest)

                return result.first as? Dictionary<String,Any>
                
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
    
    private func mainManagedObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        return managedContext
    }
    
    func save() {
        save(context: self.mainManagedObjectContext()!)
    }
    
    func save(onBackground managedContext: (NSManagedObjectContext)) {
        save(context: managedContext);
    }
    
    private func save(context: NSManagedObjectContext) {
        
        let managedContext = context
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
