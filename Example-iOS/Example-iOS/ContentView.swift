//
//  ContentView.swift
//  Example-iOS
//
//  Created by Vitaliy Podolskiy on 24.11.2021.
//

import SwiftUI
import UpdateChecker

struct ContentView: View {
    var body: some View {
        Text("Shake your device for view log!!!")
            .padding()
            .onAppear {
                self.startChecker()
            }
    }
    
    private func startChecker() {
        let configuration = UpdateConfiguration(
            bundleIdentifier: "io.itforces.ios.timetable"
        )
        let checker = Checker(with: configuration)
        checker.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}