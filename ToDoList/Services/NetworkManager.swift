//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Денис Хафизов on 24.08.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<T: Decodable>(type: T.Type, with request: Request, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func makeRequest<T: Decodable>(type: T.Type, with request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: request.url) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCode(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

struct Request {
    let method: HTTPMethod
    let url: String
    let headers: [String: String]?

    init(method: HTTPMethod, url: String, headers: [String: String]? = nil) {
        self.method = method
        self.url = url
        self.headers = headers
    }
}

enum HTTPMethod: String {
    case get = "GET"
}
