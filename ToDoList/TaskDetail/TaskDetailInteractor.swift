//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import Foundation

protocol TaskDetailInteractorInputProtocol {
    func saveTask(task: TaskEntity)
    func updateTask(task: TaskEntity)
}

protocol TaskDetailInteractorOutputProtocol: AnyObject {
    func didSaveTask()
    func didFailToSaveTask(error: Error)
}

final class TaskDetailInteractor {
    weak var presenter: TaskDetailInteractorOutputProtocol?
    private let coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
}

extension TaskDetailInteractor: TaskDetailInteractorInputProtocol {
    func saveTask(task: TaskEntity) {
        coreDataService.addTask(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didSaveTask()
            case .failure(let error):
                self?.presenter?.didFailToSaveTask(error: error)
            }
        }
    }
    
    func updateTask(task: TaskEntity) {
        coreDataService.updateTask(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didSaveTask()
            case .failure(let error):
                self?.presenter?.didFailToSaveTask(error: error)
            }
        }
    }
}
