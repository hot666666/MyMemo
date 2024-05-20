//
//  Item.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
