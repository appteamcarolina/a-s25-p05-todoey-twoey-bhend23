//
//  TodoListViewModel.swift
//  TodoeyTwoey
//
//  Created by Brandon Henderson on 8/16/25.
//

import Foundation

enum TodoListLoadingState {
        // TODO: Implement TodoListLoadingState
        // with success, error, loading, and idle states
    case idle
    case success([Todo])
    case error(Error)
    case loading
}

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var state: TodoListLoadingState = .idle
    
    func fetchTodos() async {
        do {
            let todos = try await TodoListService.getTodos()
            // TODO: Set state to success
            state = .success(todos)
        } catch {
            // TODO: Set state to error
            state = .error(error)
        }
    }
    
    func createTodo(title: String) async {
        // TODO: Implement createTodo using TodoListService.create() (see fetchTodos)
        do {
            let created = try await TodoListService.create(newTodo: NewTodo(title: title))
            if case .success(let current) = state {
                state = .success(current + [created])
            } else {
                await fetchTodos()
            }
        }
        catch {
            state = .error(error)
        }
    }
    
    func delete(todo: Todo) async {
        // TODO: Implement delete
        do {
            try await TodoListService.delete(todo: todo)
            if case .success(let current) = state {
                state = .success(current.filter { $0.id != todo.id })
            } else {
                await fetchTodos()
            }
        } catch {
            state = .error(error)
        }
    }
    
    func toggleCompletion(for todo: Todo) async {
        // TODO: Implement toggleCompletion
        do {
            let newValue = !todo.isCompleted
            try await TodoListService.updateCompletion(for: todo, isCompleted: newValue)
            if case .success(var current) = state {
                if let idx = current.firstIndex(where: { $0.id == todo.id }) {
                    current[idx].isCompleted = newValue
                    state = .success(current)
                }
            } else {
                await fetchTodos()
            }
        }
        catch {
            state = .error(error)
        }
    }
}
