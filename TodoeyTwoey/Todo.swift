//
//  Todo.swift
//  TodoeyTwoey
//
//  Created by Brandon Henderson on 8/16/25.
//

import Foundation

struct NewTodo: Codable {
    let title: String
}

struct Todo: Identifiable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}
