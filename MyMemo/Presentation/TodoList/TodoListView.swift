//
//  TodoView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct TodoListView: View {
    @Environment(TodoListViewModel.self) private var todoListViewModel
    
    var body: some View {
        ZStack{
            if todoListViewModel.todoList.isEmpty {
                DefaultView(title: "투두리스트를\n추가해 보세요.", subTitle: "\"아침 헬스장 가기\"\n\"도서관 가기\"\n\"밥 잘 먹기\"")
                    .padding(20)
            } else {
                TopRightButtonView(action: {
                    todoListViewModel.topRightButtonTapped()
                }, btnType: todoListViewModel.topRightButtonViewType)
                    .padding(20)
                TodoListContentView()
                    .padding(20)
            }
            
            if !todoListViewModel.isEditTodoMode {
                FloatingButtonView(action: {
                    todoListViewModel.toggleIsDisplayTodoDetail()
                })
                .padding(.trailing, 20)
            }
        }
        .sheet(isPresented: Bindable(todoListViewModel).isDisplayTodoDetail, content: {
            TodoDetailView()
        })
        .alert(isPresented: Bindable(todoListViewModel).isShowingAlert){
            Alert(
                title: Text("알림"),
                message: Text("\(todoListViewModel.removeTodoListCount)개를 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("확인")) {
                    todoListViewModel.removeSelectedItems()
                },
                secondaryButton: .cancel(Text("취소")) {
                    todoListViewModel.removeSelectedItems(isCanceled: true)
                }
            )
        }
        .environment(todoListViewModel)
    }
}

private struct TodoListContentView: View {
    @Environment(TodoListViewModel.self) var vm
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(vm.todoListCount)개의 할 일이\n있습니다.")
                .font(.title)
                .bold()
                .padding(.bottom, 30)
            
            Text("할일 목록")
                .bold()
            
            ScrollView {
                Divider()
                ForEach(vm.todoList){ todo in
                    TodoListContentCellView(todo: todo)
                    Divider()
                }
            }
            
            Spacer()
        }
    }
}

private struct TodoListContentCellView: View {
    @Environment(TodoListViewModel.self) var vm
    let todo: Todo
    
    var body: some View {
        HStack{
            if !vm.isEditTodoMode{
                Button(
                    action: {
                        vm.updateTodoIsDone(todo)
                    },
                    label: { todo.isDone ? Image(systemName: "checkmark.square.fill") : Image(systemName: "square") }
                )
                .font(.title)
            }
            
            VStack(alignment: .leading){
                Text(todo.title)
                    .strikethrough(todo.isDone)
                Text("\(todo.day.formattedDay) - \(todo.time.formattedTime)")
            }
            
            Spacer()
            
            if vm.isEditTodoMode {
                Button(
                    action: {
                        vm.tapTodoInEditMode(todo)
                    },
                    label: { vm.isSelectedInEditMode(todo) ? Image(systemName: "circlebadge.fill") : Image(systemName: "circlebadge") }
                )
                .font(.title)
            }
        }
        .foregroundColor(todo.isDone ? .secondary : .primary)
    }
}


#Preview("TodoList") {
    let todoListViewModel: TodoListViewModel = .init(todoList: Todo.stub)
    return TodoListView().environment(todoListViewModel)
}
