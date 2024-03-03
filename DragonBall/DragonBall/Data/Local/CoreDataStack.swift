//
//  CoreDataStack.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 2/16/24.
//

import Foundation
import CoreData

// MARK: - ManagedObjectConvertible Protocol
// This protocol defines a contract to convert domain models to their corresponding CoreData Managed Objects.
protocol ManagedObjectConvertible {
    associatedtype ManagedObject
    
    // Attempts to convert the current object to its corresponding Managed Object within a given CoreData context.
    // Returns the resulting Managed Object or nil if conversion fails.
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
}

// MARK: - ModelConvertible Protocol
// This protocol defines a contract to convert CoreData Managed Objects to domain models.
protocol ModelConvertible {
    associatedtype Model
    
    // Converts the CoreData Managed Object to its corresponding domain model.
    // Returns the model or nil if conversion is not possible.
    func toModel() -> Model?
}

// MARK: - CoreDataStack Class
// This class manages the CoreData stack for the application, providing centralized access to the persistent container.
class CoreDataStack: NSObject {
    // Singleton to access the CoreDataStack instance throughout the application.
    static let shared: CoreDataStack = .init()
    
    // Private constructor to prevent creation of multiple instances of CoreDataStack.
    private override init() {}
    
    // Persistent container encapsulating the CoreData model of the application.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DragonBall")
        container.loadPersistentStores { (storeDescription, error) in
            // Error handling when loading persistent stores.
            if let error = error as NSError? {
                // It is recommended to handle this error more appropriately in a real application, possibly logging it or showing an alert to the user.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Saves changes in the managed object context if there are pending changes.
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // CoreData error is caught and a fatal error is thrown.
                // In a real application, it is preferable to handle this error more gracefully.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
