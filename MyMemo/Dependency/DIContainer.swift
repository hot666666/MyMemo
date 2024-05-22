//
//  DIContainer.swift
//  MyMemo
//
//  Created by 최하식 on 5/22/24.
//

import Foundation

@Observable
final class DIContainer {
    let diskStorage: DiskStorageType
    let audioRecordService: AudioRecordServiceType
    
    init(diskStorage: DiskStorageType = DiskStorage(), audioRecordService: AudioRecordServiceType = AudioRecordService()) {
        self.diskStorage = diskStorage
        self.audioRecordService = audioRecordService
    }
}
