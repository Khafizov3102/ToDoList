//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool

}

extension Task : Identifiable {

}
