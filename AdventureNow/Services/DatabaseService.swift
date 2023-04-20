//
//  DatabaseService.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 18/04/2023.
//

import CoreData

class DatabaseService {

    static let shared = DatabaseService()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoritesCities")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
