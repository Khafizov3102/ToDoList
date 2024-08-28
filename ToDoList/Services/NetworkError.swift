//
//  NetworkError.swift
//  ToDoList
//
//  Created by Денис Хафизов on 27.08.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case statusCode(Int)
    case noData
    case decodingError
}
