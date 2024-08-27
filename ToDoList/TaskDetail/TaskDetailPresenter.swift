//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import Foundation

protocol TaskDetailPresenterProtocol {
    func viewDidLoad()
    func didTapSaveButton(title: String, description: String, isCompleted: Bool)
}

protocol TaskDetailViewProtocol: AnyObject {
    func setupView(task: TaskEntity?)
    func showError(message: String)
    func dismissView()
}

final class TaskDetailPresenter {
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorInputProtocol?
    var router: TaskDetailRouterProtocol?
    var task: TaskEntity?
}

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
    func viewDidLoad() {
        view?.setupView(task: task)
    }
    
    func didTapSaveButton(title: String, description: String, isCompleted: Bool) {
        guard !title.isEmpty else {
            view?.showError(message: "Название задачи не может быть пустым")
            return
        }
        
        let taskEntity = TaskEntity(
            id: task?.id ?? Int64(Date().timeIntervalSince1970),
            title: title,
            description: description,
            createdAt: task?.createdAt ?? Date(),
            isCompleted: isCompleted
        )
        
        if task != nil {
            interactor?.updateTask(task: taskEntity)
        } else {
            interactor?.saveTask(task: taskEntity)
        }
    }
}

extension TaskDetailPresenter: TaskDetailInteractorOutputProtocol {
    func didSaveTask() {
        view?.dismissView()
        router?.navigateBack()
    }
    
    func didFailToSaveTask(error: Error) {
        view?.showError(message: error.localizedDescription)
    }
    
}
