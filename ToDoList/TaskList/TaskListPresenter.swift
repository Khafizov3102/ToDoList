//
//  Presenter.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import Foundation

protocol TaskListPresenterProtocol {
    func viewDidLoad()
    func didSelectTask(task: TaskEntity)
    func didTapAddButton()
    func didSwipeToDeleteTask(task: TaskEntity)
}

protocol TaskListViewProtocol: AnyObject {
    func showTasks(tasks: [TaskEntity])
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

final class TaskListPresenter {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorInputProtocol?
    var router: TaskListRouterProtocol?
    private var tasks = [TaskEntity]()
}

extension TaskListPresenter: TaskListPresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchTask()
    }

    func didSelectTask(task: TaskEntity) {
        router?.navigateToTaskDetail(task: task)
    }

    func didTapAddButton() {
        router?.navigateToTaskDetail(task: nil)
    }

    func didSwipeToDeleteTask(task: TaskEntity) {
        interactor?.deleteTask(task: task)
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(tasks: [TaskEntity]) {
        self.tasks = tasks
        view?.hideLoading()
        view?.showTasks(tasks: tasks)
    }

    func didFailToFetchTasks(error: Error) {
        view?.hideLoading()
        view?.showError(message: error.localizedDescription)
    }

    func didDeleteTask() {
        interactor?.fetchTask()
    }

    func didFailToDeleteTask(error: Error) {
        view?.showError(message: error.localizedDescription)
    }
}
