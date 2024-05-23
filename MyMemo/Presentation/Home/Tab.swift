//
//  Tab.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation


enum Tab: String, CaseIterable {
    case todoList = "할일 목록"
    case textMemo = "메모"
    case voiceMemo = "음성메모"
    case timer = "타이머"
    case setting = "설정"
    
    
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
