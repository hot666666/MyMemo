//
//  Tab.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation


enum Tab: String, CaseIterable {
    case todoList = "TodoList"
    case textMemo = "TextMemo"
    case voiceMemo = "VoiceMemo"
    case timer = "Timer"
    case setting = "Setting"
    
    
    var systemImage: String {
        switch self {
        case .todoList:
            return "text.badge.checkmark"
        case .textMemo:
            return "doc.text"
        case .voiceMemo:
            return "mic"
        case .timer:
            return "timer"
        case .setting:
            return "gearshape"
        }
    }
}
