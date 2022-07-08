//
//  RunnerApp.swift
//  wannasit WatchKit Extension
//
//  Created by Anawach Anantachoke on 6/7/2565 BE.
//

import SwiftUI

@main
struct RunnerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
