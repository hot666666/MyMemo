//
//  TodoRealmService.swift
//  MyMemo
//
//  Created by 최하식 on 5/23/24.
//

import Foundation

protocol TodoRealmServiceType {
    func fetchAllTodos() -> [Todo]
    func saveTodo(_ todo: Todo) -> Todo
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
}

final class TodoRealmService: TodoRealmServiceType {
    private let dataRepository: RealmRepositoryProtocol

    init(dataRepository: RealmRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func fetchAllTodos() -> [Todo] {
        return dataRepository.fetchAll(TodoEntity.self).map { $0.toModel() }
    }

    func saveTodo(_ todo: Todo) -> Todo {
        let todoEntity = todo.toEntity()
        dataRepository.save(todoEntity)
        return todoEntity.toModel()
    }

    func updateTodo(_ todo: Todo) {
        dataRepository.update(todo.toEntity())
    }

    func deleteTodo(_ todo: Todo) {
        if let todoEntity = dataRepository.existingObject(TodoEntity.self, by: todo.id) {
            dataRepository.delete(todoEntity)
        }
    }
}
