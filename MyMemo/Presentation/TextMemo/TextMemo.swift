//
//  TextMemo.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation

@Observable
class TextMemo: Identifiable, Hashable {
    let id: String
    var title: String
    var content: String
    var day: Date
    
    init(id: String = UUID().uuidString, title: String = "", content: String = "", day: Date = .now) {
        self.id = id
        self.title = title
        self.content = content
        self.day = day
    }
    
    static func == (lhs: TextMemo, rhs: TextMemo) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TextMemo {
    func toEntity() -> TextMemoEntity {
        return TextMemoEntity(textMemo: self)
    }
}

extension TextMemo {
    static let stub = [TextMemo(title: "title1", content: "content1"), TextMemo(title: "title2", content: "content2"), TextMemo(title: "title3", content: "content3")]
}
