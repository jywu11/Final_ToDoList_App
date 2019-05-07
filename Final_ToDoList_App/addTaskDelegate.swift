//
//  addTaskDelegate.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu  on 16/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation

protocol AddTaskDelegate: AnyObject {
    func addTask(newTask: ShoppingItem) -> Bool
}
