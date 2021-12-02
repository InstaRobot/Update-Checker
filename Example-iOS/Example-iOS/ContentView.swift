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
        Text("Shake your device to view log!!!")
            .padding()
            .onAppear {
                self.startChecker()
            }
    }
    
    private func startChecker() {
        let configuration = UpdateConfiguration(
            bundleIdentifier: "io.itforces.ios.timetable",
            daysBeforeCheck: 0
        )
        let checker = Checker(with: configuration) { results in
            switch results {
            case .success(let updateResults):
                print(updateResults)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        checker.check()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
