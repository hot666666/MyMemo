//
//  HomeView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct HomeView: View {
    @State var activeTab: Tab = .voiceMemo
    @State var todoListViewModel: TodoListViewModel = .init()
    
    var body: some View {
        VStack {
            TabView(selection: $activeTab) {
                TodoListView()
                    .environment(todoListViewModel)
                    .tag(Tab.todoList)
                
                TextMemoView()
                    .tag(Tab.textMemo)
                
                VoiceMemoView()
                    .tag(Tab.voiceMemo)
                
                TimerView()
                    .tag(Tab.timer)
                
                SettingView()
                    .tag(Tab.setting)
            }
            
            CustomTabBar()
        }
    }
    
    func CustomTabBar(_ tint: Color = .primary, _ inactiveTint: Color = .secondary) -> some View {
        VStack{
            HStack(alignment: .top) {
                ForEach(Tab.allCases, id: \.rawValue) {
                    TabItem(
                        tint: tint,
                        inactiveTint: inactiveTint,
                        tab: $0,
                        activeTab: $activeTab
                    )
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.1).gradient) /// TabBar Color
        }
        .shadow(radius: 30)
    }
}

private struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)  /// TabItem Size
                .foregroundColor(activeTab == tab ? tint : inactiveTint)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())  /// TabItem Border를 터치영역과 동일하게 만들어줌
        .onTapGesture {
            activeTab = tab
        }
    }
}

#Preview {
    HomeView()
}
