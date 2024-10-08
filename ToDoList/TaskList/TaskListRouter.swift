//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import UIKit

protocol TaskListRouterProtocol {
    func navigateToTaskDetail(task: TaskEntity?)
}

final class TaskListRouter {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = TaskListViewController()
        let presenter = TaskListPresenter()
        
        let networkManager = NetworkManager()
        let tasksService = TasksService(networkManager: networkManager)
        let coreDataService = CoreDataService()
        let interactor = TaskListInteractor(tasksService: tasksService, coreDataService: coreDataService)
        
        let router = TaskListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension TaskListRouter: TaskListRouterProtocol {
    func navigateToTaskDetail(task: TaskEntity? = nil) {
        let taskDetailVC = TaskDetailRouter.createModule(task: task)
        viewController?.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
