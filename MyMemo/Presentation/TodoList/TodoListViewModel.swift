//
//  TodoListViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation
import SwiftUI

@Observable
class TodoListViewModel {
    var todoList: [Todo]
    var removeTodoList = Set<Todo>()
    var isDisplayTodoDetail = false
    var isEditTodoMode = false
    var isShowingAlert = false
    
    @ObservationIgnored var updateTodo: Bindable<Todo>?
    @ObservationIgnored var container: DIContainer
    
    init(container: DIContainer, todoList: [Todo] = []){
        self.container = container
        self.todoList = todoList
    }
}

extension TodoListViewModel {
    var topRightButtonViewType: TopRightButtonViewType {
      isEditTodoMode ? .complete : .edit
    }
    
    var todoListCount: Int {
        todoList.count
    }
    
    var removeTodoListCount: Int {
        removeTodoList.count
    }
    
    func isSelectedInEditMode(_ todo: Todo) -> Bool {
        removeTodoList.contains(where: {todo.id == $0.id})
    }
    
    func tapTodoInEditMode(_ todo: Todo){
        if removeTodoList.contains(where: {todo.id == $0.id}) {
            removeTodoList.remove(todo)
        } else {
            removeTodoList.insert(todo)
        }
    }
        
    func topRightButtonTapped() {
        if !isEditTodoMode {
            isEditTodoMode = true
        } else {
            if !removeTodoList.isEmpty {
                isShowingAlert = true
            }
            isEditTodoMode = false
        }
    }
    
    func tapTodoListItem(with todo: Bindable<Todo>) {
        updateTodo = todo
        isDisplayTodoDetail.toggle()
    }
    
    func toggleIsDisplayTodoDetail(){
        isDisplayTodoDetail.toggle()
    }
    
    func updateTodoIsDone(_ todo: Bindable<Todo>){
        todo.wrappedValue.isDone.toggle()
        updateTodo(todo.wrappedValue)
    }
}

extension TodoListViewModel {
    func fetchTodo(){
        todoList = container.todoRealmService.fetchAllTodos()
    }
    
    func addTodo(_ todo: Todo){
        let newTodo = container.todoRealmService.saveTodo(todo)
        todoList.append(newTodo)
    }
    
    func updateTodo(_ todo: Todo){
        container.todoRealmService.updateTodo(todo)
    }
    
    func removeSelectedItems(isCanceled: Bool = false) {
        if !isCanceled {
            removeTodoList.forEach { container.todoRealmService.deleteTodo($0) }
            todoList.removeAll { removeTodoList.contains($0) }
        }
        removeTodoList.removeAll()
    }
}
