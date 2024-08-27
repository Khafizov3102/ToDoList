//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Денис Хафизов on 25.08.2024.
//

import UIKit

final class TaskDetailViewController: UIViewController, TaskDetailViewProtocol {
    var presenter: TaskDetailPresenterProtocol?
    
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let completedSwitch = UISwitch()
    private let saveButton = UIButton(type: .system)
    private let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Детали задачи"
        
        titleTextField.placeholder = "Название"
        titleTextField.borderStyle = .roundedRect
        
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 5
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleTextField, descriptionTextView, dateLabel, completedSwitch, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func saveButtonTapped() {
        presenter?.didTapSaveButton(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text ?? "",
            isCompleted: completedSwitch.isOn
        )
    }
    
    func setupView(task: TaskEntity?) {
        titleTextField.text = task?.title
        descriptionTextView.text = task?.description
        dateLabel.text = task?.createdAt.description
        completedSwitch.isOn = task?.isCompleted ?? false
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func dismissView() {
        navigationController?.popViewController(animated: true)
    }
}
