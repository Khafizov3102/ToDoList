//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Денис Хафизов on 24.08.2024.
//

import Foundation

protocol TaskListInteractorInputProtocol {
    func fetchTask()
    func deleteTask(task: TaskEntity)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(tasks: [TaskEntity])
    func didFailToFetchTasks(error: Error)
    func didDeleteTask()
    func didFailToDeleteTask(error: Error)
}

final class TaskListInteractor {
    weak var presenter: TaskListInteractorOutputProtocol?
    private let networkManager: NetworkManagerProtocol
    private let coreDatasService: CoreDataServiceProtocol
    private let userDefaults = UserDefaults.standard
    
    init(networkManager: NetworkManagerProtocol, coreDataService: CoreDataServiceProtocol) {
        self.networkManager = networkManager
        self.coreDatasService = coreDataService
    }
}

//MARK: TaskListInteractorInputProtocol
extension TaskListInteractor: TaskListInteractorInputProtocol {
    func fetchTask() {
        if userDefaults.bool(forKey: "hasLoadedInitialData") {
            coreDatasService.fetchTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    self?.presenter?.didFailToFetchTasks(error: error)
                }
            }
        } else {
            networkManager.fetchTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.coreDatasService.saveTasks(tasks, completion: { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.userDefaults.set(true, forKey: "hasLoadedInitialData")
                            self?.presenter?.didFetchTasks(tasks: tasks)
                        case .failure(let error):
                            self?.presenter?.didFailToFetchTasks(error: error)
                        }
                    })
                case .failure(let error):
                    self?.presenter?.didFailToFetchTasks(error: error)
                }
            }
        }
    }
    
    func deleteTask(task: TaskEntity) {
        coreDatasService.deleteTask(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didDeleteTask()
            case .failure(let error):
                self?.presenter?.didFailToDeleteTask(error: error)
            }
        }
    }
}
