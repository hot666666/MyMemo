//
//  NotificationService.swift
//  MyMemo
//
//  Created by 최하식 on 5/23/24.
//

import UserNotifications

protocol NotificationServiceType {
    var isAuthorized: Bool { get }
    func requestAuthorization()
    func sendNotification()
}

final class NotificationService: NotificationServiceType {
    private var notificationCenter: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }
    
    var isAuthorized: Bool {
        var authorizationStatus: UNAuthorizationStatus?
        notificationCenter.getNotificationSettings { settings in
            authorizationStatus = settings.authorizationStatus
        }
        return authorizationStatus == .authorized
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Authorization request error: \(error)")
            } else if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }
    }

    
    func sendNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: createTimerContent(),
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                // Handle error
                print("Notification error: \(error)")
            }
        }
    }
    
    func createTimerContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "타이머 종료!"
        content.body = "설정한 타이머가 종료되었습니다."
        content.sound = UNNotificationSound.default
        return content
    }
}
