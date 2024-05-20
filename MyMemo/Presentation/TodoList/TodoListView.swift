//
//  TodoView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct Todo: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var time: Data
    var isDone: Bool
    
    init(title: String, date: Date, time: Data, isDone: Bool) {
        self.title = title
        self.date = date
        self.time = time
        self.isDone = isDone
    }
}

struct TodoListView: View {
    @State var todoList = [Todo]()
    
    var body: some View {
        if todoList.isEmpty {
            DefaultView(title: "투두 리스트를\n추가해 보세요.", subTitle: "\"아침 헬스장 가기\"\n\"도서관 가기\"\n\"밥 잘 먹기\"")
        } else {
            Text("요기")
        }
    }
}

#Preview {
    TodoListView()
}
