//
//  TodoListViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation
import Observation

@Observable
class TodoListViewModel {
    var todoList: [Todo]
    var removeTodoList = Set<Todo>()
    var isDisplayTodoDetail = false
    var isEditTodoMode = false
    var isShowingAlert = false
    
    init(todoList: [Todo] = []){
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
    
    func addTodo(_ todo: Todo){
        todoList.append(todo)
    }
    
    func updateTodoIsDone(_ todo: Todo){
        if let index = todoList.firstIndex(where: {todo.id == $0.id}){
            todoList[index].isDone.toggle()
        }
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
    
    func removeSelectedItems(isCanceled: Bool = false) {
        if !isCanceled{
            todoList.removeAll { todo in
                removeTodoList.contains(todo)
            }
        }
        removeTodoList.removeAll()
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
    
    func toggleIsDisplayTodoDetail(){
        isDisplayTodoDetail.toggle()
    }
}
