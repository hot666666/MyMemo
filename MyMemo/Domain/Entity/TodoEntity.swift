//
//  TodoEntity.swift
//  MyMemo
//
//  Created by 최하식 on 5/23/24.
//

import Foundation
import RealmSwift

class TodoEntity: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var day: Date = Date()
    @objc dynamic var time: Date = Date()
    @objc dynamic var isDone: Bool = false
    
    convenience init(todo: Todo) {
        self.init()
        self.id = todo.id
        self.title = todo.title
        self.day = todo.day
        self.time = todo.time
        self.isDone = todo.isDone
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}


extension TodoEntity {
    func toModel() -> Todo {
        return Todo(id: id, title: title, day: day, time: time, isDone: isDone)
    }
}
