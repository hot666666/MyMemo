//
//  HomeViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation

@Observable
class HomeViewModel {
    var activeTab: Tab = .voiceMemo
    
    var todosCount: Int = 0
    var memosCount: Int = 0
    var voiceMemosCount: Int = 0
    
    @ObservationIgnored var availableTabs: [Tab] {
        Tab.allCases.filter { $0 != Tab.setting }
    }
    
    func setTodosCount(_ count: Int) {
        todosCount = count
    }
    
    func setMemosCount(_ count: Int) {
        memosCount = count
    }
    
    func setVoiceMemosCount(_ count: Int) {
        voiceMemosCount = count
    }
    
    func onTapTabViewItem(selected: Tab){
        activeTab = selected
    }
}
