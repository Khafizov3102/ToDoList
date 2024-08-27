//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Денис Хафизов on 24.08.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchTasks(completion: @escaping (Result<[TaskEntity], NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func fetchTasks(completion: @escaping (Result<[TaskEntity], NetworkError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: "https://dummyjson.com/todos") else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidURL))
                }
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.noData))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(TaskAPIResponse.self, from: data)
                    let tasks = response.todos.map { apiTask in
                        TaskEntity(
                            id: Int64(apiTask.id),
                            title: apiTask.todo,
                            description: "",
                            createdAt: Date(),
                            isCompleted: apiTask.completed
                        )
                    }
                    DispatchQueue.main.async {
                        completion(.success(tasks))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
            }
            task.resume()
        }
    }
}



struct TaskAPIResponse: Codable {
    let todos: [TaskAPIModel]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TaskAPIModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
