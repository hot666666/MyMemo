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
    let notificationService: NotificationServiceType
    
    init(diskStorage: DiskStorageType = DiskStorage(),
         audioRecordService: AudioRecordServiceType = AudioRecordService(),
         notificationService: NotificationServiceType = NotificationService()) {
        self.diskStorage = diskStorage
        self.audioRecordService = audioRecordService
        self.notificationService = notificationService
    }
}
