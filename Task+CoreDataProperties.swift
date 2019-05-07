//
//  Task+CoreDataProperties.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu on 17/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var name: String
    @NSManaged public var category: String

}
