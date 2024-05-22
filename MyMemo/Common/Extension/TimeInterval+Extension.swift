//
//  TimeInterval+Extension.swift
//  MyMemo
//
//  Created by 최하식 on 5/21/24.
//

import Foundation

extension TimeInterval {
    var formattedTimeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
