//
//  TaskCell.swift
//  ToDoList
//
//  Created by Денис Хафизов on 27.08.2024.
//

import UIKit

final class TaskCell: UITableViewCell {
    func configure(with task: TaskEntity) {
        textLabel?.text = task.title
        detailTextLabel?.text = task.description
        accessoryType = task.isCompleted ? .checkmark : .none
    }
}
