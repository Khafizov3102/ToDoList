//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import UIKit

protocol TaskDetailRouterProtocol {
    func navigateBack()
}

final class TaskDetailRouter {
    weak var viewController: UIViewController?

    static func createModule(task: TaskEntity? = nil) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter()
        let interactor = TaskDetailInteractor(coreDataService: CoreDataService())
        let router = TaskDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        presenter.task = task

        return view
    }
}

extension TaskDetailRouter: TaskDetailRouterProtocol {
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
