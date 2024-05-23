//
//  TimerViewModel.swift
//  MyMemo
//
//  Created by 최하식 on 5/22/24.
//

import Foundation
import SwiftUI

@Observable
class TimerViewModel {
    @ObservationIgnored var container: DIContainer
    
    var isTimerView: Bool = false
    
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    
    var isPaused: Bool = true
    
    var timer: Timer?
    
    var timeRemaining: TimeInterval = 0
    var timerTime: TimeInterval = 0
    
    var animationValue = 0.0
    
    var isSettable: Bool {
        hour == 0 && minute == 0 && second == 0
    }
    
    init(container: DIContainer){
        self.container = container
    }
}

extension TimerViewModel {
    func setBtnTapped() {
        timerTime = TimeInterval(3600*hour+60*minute+second)
        timeRemaining = timerTime
        isTimerView = true
    }
    
    func pauseOrRestartBtnTapped() {
        if isPaused {
            startTimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
        isPaused.toggle()
    }
    
    func cancelBtnTapped(){
        stopTimer()
        isTimerView = false
    }
    
    func onAppearTimer() {
        isPaused = true
        animationValue = 0
    }
    
    private func startTimer() {
        guard timer == nil else { return }
        
        if !container.notificationService.isAuthorized {
            container.notificationService.requestAuthorization()
        }
        
        var backgroundTaskID: UIBackgroundTaskIdentifier?
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            /// completion hanlder(endBackgroundTask, .invalid UIBackgroundTaskIdentifier)
            if let task = backgroundTaskID {
                UIApplication.shared.endBackgroundTask(task)
                backgroundTaskID = .invalid
            }
        }
        
        /// background task
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                withAnimation{
                    self.animationValue = 1 - (Double(self.timeRemaining) / self.timerTime)
                }
            } else {
                self.stopTimer()
                self.container.notificationService.sendNotification()
                
                if let task = backgroundTaskID {
                    UIApplication.shared.endBackgroundTask(task)
                    backgroundTaskID = .invalid
                }
                
                self.isTimerView = false
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
