//
//  TaskAPIModel.swift
//  ToDoList
//
//  Created by Денис Хафизов on 28.08.2024.
//

import Foundation

struct TaskAPIModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TaskAPIResponse: Codable {
    let todos: [TaskAPIModel]
    let total: Int
    let skip: Int
    let limit: Int
}
