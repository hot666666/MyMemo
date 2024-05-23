//
//  SettingView.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(HomeViewModel.self) private var homeViewModel
    
    var body: some View {
        VStack{
            titleView
            
            Spacer()
              .frame(height: 35)
            
            HStack(spacing: 70){
                InfoView(title: "할일", count: homeViewModel.todosCount)
                InfoView(title: "메모", count: homeViewModel.memosCount)
                InfoView(title: "음성메모", count: homeViewModel.voiceMemosCount)
            }
            
            Spacer()
              .frame(height: 35)
            
            Divider()
            ForEach(homeViewModel.availableTabs, id: \.self){ tab in
                TabButtonView(tab: tab, action: {
                    homeViewModel.onTapTabViewItem(selected: tab)
                })
            }
            Divider()
            
            Spacer()
        }
    }
    
    var titleView: some View {
        Text("설정")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title)
            .bold()
            .padding()
    }
    
    func InfoView(title: String, count: Int) -> some View {
        VStack{
            Text(title)
            Text(count.description)
                .font(.title)
        }
    }
    
    func TabButtonView(tab: Tab, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            HStack{
                Text(tab.rawValue)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "chevron.right")
                    .opacity(0.5)
            }
        })
        .padding(20)
        .foregroundColor(.primary)
    }
}

#Preview {
    let homeViewModel: HomeViewModel = .init()
    return SettingView().environment(homeViewModel)
}
