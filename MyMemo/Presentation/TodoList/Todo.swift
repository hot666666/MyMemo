//
//  Todo.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation

@Observable
class Todo: Identifiable, Hashable {
    var id: String
    var title: String
    var day: Date
    var time: Date
    var isDone: Bool
    
    init(id: String = UUID().uuidString, title: String = "", day: Date = .now, time: Date = .now, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.day = day
        self.time = time
        self.isDone = isDone
    }
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Todo {
    func toEntity() -> TodoEntity {
        return TodoEntity(todo: self)
    }
}

extension Todo {
    static let stub = [Todo(title: "title1"), Todo(title: "title2"), Todo(title: "title3")]
}
