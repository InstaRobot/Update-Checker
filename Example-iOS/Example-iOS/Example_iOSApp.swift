//
//  Example_iOSApp.swift
//  Example-iOS
//
//  Created by Vitaliy Podolskiy on 24.11.2021.
//

import SwiftUI
import netfox

@main
struct Example_iOSApp: App {
    init() {
        startNetfox()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func startNetfox() {
        NFX.sharedInstance().start()
    }
}
