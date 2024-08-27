//
//  Task.swift
//  ToDoList
//
//  Created by Денис Хафизов on 24.08.2024.
//

import Foundation

struct TaskEntity {
    let id: Int64
    let title: String
    let description: String
    let createdAt: Date
    var isCompleted: Bool
}
