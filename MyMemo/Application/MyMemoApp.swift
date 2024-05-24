//
//  MyMemoApp.swift
//  MyMemo
//
//  Created by 최하식 on 5/20/24.
//

import SwiftUI
import SwiftData

@main
struct MyMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        @State var container: DIContainer = .init()
        
        WindowGroup {
            HomeView(container: container)
                .environment(container)
        }
    }
}
