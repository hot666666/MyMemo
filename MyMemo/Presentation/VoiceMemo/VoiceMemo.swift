//
//  VoiceMemo.swift
//  MyMemo
//
//  Created by 최하식 on 5/21/24.
//

import Foundation

struct VoiceMemo: Identifiable, Hashable {
    let id = UUID()
    var title: String
    let day: Date
    let duration: TimeInterval
    let fileURL: URL
    
    init(title: String, day: Date, duration: TimeInterval, fileURL: URL) {
        self.title = title
        self.day = day
        self.duration = duration
        self.fileURL = fileURL
    }
}
