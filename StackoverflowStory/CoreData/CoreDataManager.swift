//
//  CoreDataManager.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//
import CoreData
import UIKit

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private let dataModelName = "StackoverflowStory"
    private override init() {}
    //in app delegate - core data stack (all of it)
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        let description = NSPersistentStoreDescription()
        description.url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(dataModelName + ".sqlite")
        container.persistentStoreDescriptions = [description]
        //assertionFailure in debug it doesn't crash but in perdiction is does
        container.loadPersistentStores(completionHandler: {_, error in
            if let error = error {
                assertionFailure("\(error)")
            }
        })
        return container
    }()
    func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            assertionFailure("Could not save: \(error)")
        }
    }
    //reusable fetch method, <T: generic>
    func fetchObjects<T>(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) -> [T] {
        do {
            return try context.fetch(fetchRequest)
        } catch {
            assertionFailure("\(error)")
        }
        return []
    }
    func batchDelete(objects: [NSManagedObject], context: NSManagedObjectContext) {
        let objectIDs: [NSManagedObjectID] = objects.map { $0.objectID }
        let deleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
        do {
            try context.execute(deleteRequest)
        } catch {
            assertionFailure("\(error)")
        }
    }
}
