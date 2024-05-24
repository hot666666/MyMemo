//
//  MemoEntity.swift
//  MyMemo
//
//  Created by 최하식 on 5/23/24.
//

import Foundation
import RealmSwift

class TextMemoEntity: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var day: Date = Date()
    
    convenience init(textMemo: TextMemo) {
        self.init()
        self.id = textMemo.id
        self.title = textMemo.title
        self.content = textMemo.content
        self.day = textMemo.day
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension TextMemoEntity {
    func toModel() -> TextMemo {
        return TextMemo(id: id, title: title, content: content, day: day)
    }
}
