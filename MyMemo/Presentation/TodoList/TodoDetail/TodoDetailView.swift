//
//  TodoDetailView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

private enum ViewMode {
    case create
    case update
}

struct TodoDetailView: View {
    @Environment(TodoListViewModel.self) var vm
    @State var todo: Todo
    @State var isDisplayCalendar = false
    
    private var originalTodo: Bindable<Todo>?
    private var viewMode: ViewMode {
        originalTodo == nil ? .create : .update
    }
    
    init(originalTodo: Bindable<Todo>? = nil){
        if let originalTodo = originalTodo {
            _todo = State(wrappedValue: originalTodo.wrappedValue)
            self.originalTodo = originalTodo
        } else {
            _todo = State(wrappedValue: Todo())
        }
    }
    
    var body: some View {
        ZStack{
            Text(viewMode == .create ? "투두리스트를\n추가해 보세요." : "투두리스트 수정")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.title)
                .bold()
            
            TopRightButtonView(action: {
                if var originalTodo = originalTodo {
                    originalTodo.wrappedValue = todo
                    vm.updateTodo(originalTodo.wrappedValue)
                } else {
                    vm.addTodo(todo)
                }
                vm.toggleIsDisplayTodoDetail()
            }, btnType: viewMode == .create ? .create : .complete)
            .disabled(todo.title.isEmpty)
            .opacity(todo.title.isEmpty ? 0.3 : 1)
            
            VStack{
                TextField("제목을 입력하세요", text: $todo.title)
                
                SelectTimeView(todo: $todo)
                
                SelectDayView(isDisplayCalendar: $isDisplayCalendar, todo: $todo)
            }
        }
        .padding(20)
    }
}

struct SelectDayView: View {
    @Binding var isDisplayCalendar: Bool
    @Binding var todo: Todo
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("날짜")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            HStack {
                Button(
                    action: { isDisplayCalendar.toggle() },
                    label: {
                        Text("\(todo.day.formattedDay)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                    }
                )
                .popover(isPresented: $isDisplayCalendar) {
                    DatePicker(
                        "",
                        selection: $todo.day,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onChange(of: todo.day) { _, _ in
                        isDisplayCalendar.toggle()
                    }
                }
                Spacer()
            }
        }
    }
}

struct SelectTimeView: View {
    @Binding var todo: Todo
    
    var body: some View {
        VStack {
            Divider()
            
            DatePicker(
                "",
                selection: $todo.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            Divider()
        }
    }
}


#Preview("TodoDetail") {
    let todoListViewModel: TodoListViewModel = .init(container: .init())
    return TodoDetailView()
        .environment(todoListViewModel)
}

