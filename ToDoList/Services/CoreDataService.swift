//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    func saveTasks(_ tasks: [TaskEntity], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void)
    func addTask(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTask(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void)
}

class CoreDataService: CoreDataServiceProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.persistentContainer = container
    }
    
    func saveTasks(_ tasks: [TaskEntity], completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            for taskEntity in tasks {
                let task = Task(context: context)
                task.id = taskEntity.id
                task.title = taskEntity.title
                task.taskDescription = taskEntity.description
                task.createdAt = taskEntity.createdAt
                task.isCompleted = taskEntity.isCompleted
            }
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                let tasks = results.map { task in
                    TaskEntity(
                        id: task.id,
                        title: task.title ?? "",
                        description: task.taskDescription ?? "",
                        createdAt: task.createdAt ?? Date(),
                        isCompleted: task.isCompleted
                    )
                }
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func addTask(_ taskEntity: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let task = Task(context: context)
            task.id = taskEntity.id
            task.title = taskEntity.title
            task.taskDescription = taskEntity.description
            task.createdAt = taskEntity.createdAt
            task.isCompleted = taskEntity.isCompleted
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateTask(_ taskEntity: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", taskEntity.id)
            do {
                if let task = try context.fetch(fetchRequest).first {
                    task.title = taskEntity.title
                    task.taskDescription = taskEntity.description
                    task.isCompleted = taskEntity.isCompleted
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Task not found", code: 0)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteTask(_ taskEntity: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", taskEntity.id)
            do {
                if let task = try context.fetch(fetchRequest).first {
                    context.delete(task)
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Task not found", code: 0)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
