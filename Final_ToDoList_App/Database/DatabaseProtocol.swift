//
//  DatabaseProtocol.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu  on 17/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case tasks
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTaskListChange(change: DatabaseChange, tasksFromDB: [ShoppingItem])
}


protocol DatabaseProtocol: AnyObject {
    
    func addTask(name: String, category: String) -> ShoppingItem
    func deleteTask(task:ShoppingItem)
    func editTask(name: String, newName:String, category: String)
    
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
