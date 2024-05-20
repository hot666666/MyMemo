//
//  TodoDetailView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(TodoListViewModel.self) var vm
    @State var todo = Todo()
    @State var isDisplayCalendar = false
    
    var body: some View {
        ZStack{
            Text("Todo List를\n추가해 보세요.")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.title)
                .bold()
            
            TopRightButtonView(action: {
                vm.addTodo(todo)
                vm.toggleIsDisplayTodoDetail()
            }, btnType: .create)
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
    let todoListViewModel: TodoListViewModel = .init()
    return TodoDetailView()
        .environment(todoListViewModel)
}

