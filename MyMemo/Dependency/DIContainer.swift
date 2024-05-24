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
    let todoRealmService: TodoRealmServiceType
    let textMemoRealmService: TextMemoRealmServiceType
    
    init(diskStorage: DiskStorageType = DiskStorage(),
         audioRecordService: AudioRecordServiceType = AudioRecordService(),
         notificationService: NotificationServiceType = NotificationService(),
         todoRealmService: TodoRealmServiceType = TodoRealmService(dataRepository: RealmRepository()),
         textMemoRealmService: TextMemoRealmServiceType = TextMemoRealmService(dataRepository: RealmRepository())
    ) {
        self.diskStorage = diskStorage
        self.audioRecordService = audioRecordService
        self.notificationService = notificationService
        self.todoRealmService = todoRealmService
        self.textMemoRealmService = textMemoRealmService
    }
}
