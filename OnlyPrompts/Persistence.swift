//
//  Persistence.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import Foundation
import CloudKit
import CoreData
import CoreLocation

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "OnlyPrompts")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        /*
        let publicDescription = container.persistentStoreDescriptions.first!
        let storesURL = publicDescription.url!.deletingLastPathComponent()
        let identifier = publicDescription.cloudKitContainerOptions!.containerIdentifier
        publicDescription.url = storesURL.appendingPathComponent("VerseApp-public.sqlite")
        publicDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        publicDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        let publicOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: identifier)
        publicOptions.databaseScope = .public
        
        publicDescription.cloudKitContainerOptions = publicOptions
        container.persistentStoreDescriptions.append(publicDescription)
         */
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to CoreData: ", error.localizedDescription)
        }
    }
    /*
    func fetchPoems() -> [Poem] {
        let request: NSFetchRequest<Poem> = Poem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Poem.createdDate, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            return []
        }
    }
     */
}
