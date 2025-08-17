//
//  TodoListService.swift
//  TodoeyTwoey
//
//  Created by Brandon Henderson on 8/16/25.
//

import Foundation

struct TodoListService {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static let baseUrl = "https://learning.appteamcarolina.com/todos"
    
    
    
    
    static func getTodos() async throws -> [Todo] {
        // TODO: Implement. See above for request code
        guard let url = URL(string: baseUrl) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode([Todo].self, from: data)
    }
    
    
    
    
    static func create(newTodo: NewTodo) async throws -> Todo {
        // TODO: Implement
        guard let url = URL(string: baseUrl) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            request.httpBody = try encoder.encode(newTodo)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
        return Todo(id: .init(), title: "Remove Me", isCompleted: false)
    }
    
    
    
    
    
    static func delete(todo: Todo) async throws {
        // TODO: Implement
        guard let url = URL(string: "\(baseUrl)/\(todo.id.uuidString)") else {
                throw URLError(.badURL)
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
    }
    
    
    
    
    static func updateCompletion(for todo: Todo, isCompleted: Bool) async throws {
        // TODO: Implement
        
        struct UpdateBody: Codable { let completed: Bool }

        guard let url = URL(string: "\(baseUrl)/\(todo.id.uuidString)") else {
                throw URLError(.badURL)
            }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH" // use "PUT" here if the API expects full replacement
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try encoder.encode(UpdateBody(completed: isCompleted))

            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
    }
}
