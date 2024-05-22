//
//  VoiceMemoObject.swift
//  MyMemo
//
//  Created by 최하식 on 5/22/24.
//

import Foundation

struct VoiceMemoObject {
    let title: String
    let day: Date
    let duration: TimeInterval
    let fileURL: URL
}

extension VoiceMemoObject {
    func toModel() -> VoiceMemo {
        VoiceMemo(title: self.title, day: self.day, duration: self.duration, fileURL: self.fileURL)
    }
}
