//
//  TextMemo.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation

struct TextMemo: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var content: String
    var day: Date
    var time: Date
    
    init(title: String = "", content: String = "", day: Date = .now, time: Date = .now) {
        self.title = title
        self.content = content
        self.day = day
        self.time = time
    }
}

extension TextMemo {
    static let stub = [TextMemo(title: "title1", content: "content1"), TextMemo(title: "title2", content: "content2"), TextMemo(title: "title3", content: "content3")]
}
