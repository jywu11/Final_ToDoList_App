//
//  CoreDataController.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu  on 17/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol,
NSFetchedResultsControllerDelegate {


    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    var allTasksFetchedResultsController: NSFetchedResultsController <ShoppingItem>?


    
    override init() {
        persistantContainer = NSPersistentContainer(name: "ShoppingList")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()

        // FETCH ALL DATA FROM DB, TO SEE WHETHER THERE ARE ANY TASKS IN IT.
        if fetchAllTasks().count == 0 {
            createDefaultEntries()
        }
            print("\(fetchAllTasks().count) Count: Fetching all tasks from the DB.")
}

    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
}


    // Function to add task into our Core Database.
    func addTask(name: String, category: String) -> ShoppingItem {
        
        let task = NSEntityDescription.insertNewObject(forEntityName: "ShoppingItem",
                                                       into: persistantContainer.viewContext) as! ShoppingItem
        
        task.name = name
        task.category = category

        saveContext()
        return task
}
    
    // Function to delete task from our Core Database.
    func deleteTask(task: ShoppingItem) {
        persistantContainer.viewContext.delete(task)
        saveContext()
        
    }
    
    // Function to edit task from our Core Database.
    func editTask(name: String, newName: String, category: String) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest.init(entityName: "ShoppingItem")
        fetchRequest.predicate = NSPredicate(format:"name = %@",name)
        
        do{
            let test = try persistantContainer.viewContext.fetch(fetchRequest) as! [ShoppingItem]
            let update = test[0] as NSManagedObject
            update.setValue(newName, forKey: "name")
            update.setValue(category, forKey: "category")

            saveContext()
        }
        catch{
            print("Unable to Update your Task.")
        }
    }
    
    

    // Listen to the database, if there is a change, fetch all tasks.
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.tasks || listener.listenerType == ListenerType.all {
            listener.onTaskListChange(change: .update, tasksFromDB: fetchAllTasks())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
}


    // Fetches all tasks from the database and output into an array.
    func fetchAllTasks() -> [ShoppingItem] {
        if allTasksFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allTasksFetchedResultsController =
                NSFetchedResultsController<ShoppingItem>(fetchRequest: fetchRequest,
                                                      managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                                                      cacheName: nil)
            
            allTasksFetchedResultsController?.delegate = self
            
            do {
                try allTasksFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var tasks = [ShoppingItem]()
        if allTasksFetchedResultsController?.fetchedObjects != nil {
            tasks = (allTasksFetchedResultsController?.fetchedObjects)!
        }
        
        return tasks
    }
    

    // MARK: - Fetched Results Conttroller Delegate
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allTasksFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.tasks ||
                    listener.listenerType == ListenerType.all {
                    listener.onTaskListChange(change: .update, tasksFromDB:
                        fetchAllTasks())
                }
            }
        }
    }
    

    
    func createDefaultEntries() {
        let _ = addTask(name: "This is a sample Item.", category:"Dairy")
    }
}
