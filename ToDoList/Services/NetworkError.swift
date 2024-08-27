//
//  NetworkError.swift
//  ToDoList
//
//  Created by Денис Хафизов on 27.08.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
