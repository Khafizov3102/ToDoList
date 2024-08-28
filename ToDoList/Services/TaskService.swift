//
//  TaskService.swift
//  ToDoList
//
//  Created by Денис Хафизов on 28.08.2024.
//

import Foundation

protocol TasksServiceProtocol {
    func fetchTasks(completion: @escaping (Result<[TaskEntity], NetworkError>) -> Void)
}

class TasksService: TasksServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchTasks(completion: @escaping (Result<[TaskEntity], NetworkError>) -> Void) {
        let request = Request(
            method: .get,
            url: "https://dummyjson.com/todos"
        )
        
        networkManager.makeRequest(type: TaskAPIResponse.self, with: request) { result in
            switch result {
            case .success(let response):
                let tasks = response.todos.map { apiTask in
                    TaskEntity(
                        id: Int64(apiTask.id),
                        title: apiTask.todo,
                        description: "",
                        createdAt: Date(),
                        isCompleted: apiTask.completed
                    )
                }
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
