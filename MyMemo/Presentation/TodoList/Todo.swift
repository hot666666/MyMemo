//
//  Todo.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation

struct Todo: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var day: Date
    var time: Date
    var isDone: Bool
    
    init(title: String = "", day: Date = .now, time: Date = .now, isDone: Bool = false) {
        self.title = title
        self.day = day
        self.time = time
        self.isDone = isDone
    }
}

extension Todo {
    static let stub = [Todo(title: "title1"), Todo(title: "title2"), Todo(title: "title3")]
}
