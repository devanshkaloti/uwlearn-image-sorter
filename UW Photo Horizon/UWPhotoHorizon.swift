//
//  testApp.swift
//  test
//
//  Created by Devansh Kaloti on 2021-12-20.
//

import SwiftUI

@main
struct testApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}
