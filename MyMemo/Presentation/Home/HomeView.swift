//
//  HomeView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct HomeView: View {
    @State var homeViewModel: HomeViewModel = .init()
    @State var voiceMemoViewModel: VoiceMemoViewModel
    @State var timerViewModel: TimerViewModel
    @State var todoListViewModel: TodoListViewModel
    @State var textMemoViewModel: TextMemoViewModel
    
    init(container: DIContainer){
        _voiceMemoViewModel = State(wrappedValue: .init(container: container))
        _timerViewModel = State(wrappedValue: .init(container: container))
        _todoListViewModel = State(wrappedValue: .init(container: container))
        _textMemoViewModel = State(wrappedValue: .init(container: container))
        
        _todoListViewModel.wrappedValue.fetchTodo()
        homeViewModel.setTodosCount(_todoListViewModel.wrappedValue.todoListCount)
        
        _textMemoViewModel.wrappedValue.fetchTextMemo()
        homeViewModel.setMemosCount(_textMemoViewModel.wrappedValue.textMemosCount)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $homeViewModel.activeTab) {
                TodoListView()
                    .onChange(of: todoListViewModel.todoListCount) { homeViewModel.setTodosCount($1) }
                    .environment(todoListViewModel)
                    .tag(Tab.todoList)
                
                TextMemoView()
                    .onChange(of: textMemoViewModel.textMemosCount) { homeViewModel.setMemosCount($1) }
                    .environment(textMemoViewModel)
                    .tag(Tab.textMemo)
                
                VoiceMemoView()
                    .onChange(of: voiceMemoViewModel.voiceMemosCount) { homeViewModel.setVoiceMemosCount($1) }
                    .environment(voiceMemoViewModel)
                    .tag(Tab.voiceMemo)
                
                TimerView()
                    .environment(timerViewModel)
                    .tag(Tab.timer)
                
                SettingView()
                    .tag(Tab.setting)
            }
            .environment(homeViewModel)
            
            CustomTabBar()
                .shadow(radius: 1)
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
                        activeTab: $homeViewModel.activeTab
                    )
                }
            }
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8)) /// TabBar Color
            .clipShape(Capsule())  /// TabBar Shape
            .padding(.horizontal, 10)
        }
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
    let container: DIContainer = .init()
    return HomeView(container: container)
        .environment(container)
}
