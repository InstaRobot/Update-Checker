//
//  Checker.swift
//  UpdateChecker
//
//  Created by Vitaliy Podolskiy on 24.11.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

let k_CheckDateInited = "k_CheckDateInited"

public struct Checker {
    private var configuration: UpdateConfiguration
    
    public init(with configuration: UpdateConfiguration) {
        self.configuration = configuration
    }
    
    public func start() {
        assert(!configuration.bundleIdentifier.isEmpty)
        
        if var date = UserDefaults.standard.object(forKey: k_CheckDateInited) as? Date {
            let calendar = Calendar.current
            date = calendar.date(byAdding: .day, value: configuration.daysBeforeCheck, to: date) ?? date
            let result = calendar.compare(date, to: Date(), toGranularity: .day)
            switch result {
            case .orderedAscending, .orderedSame:
                Siren.shared.wail { result in
                    switch result {
                    case .success(let updateResults):
                        print("Model ", updateResults.model)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            default:
                print("cannot check")
                return
            }
        }
        else {
            UserDefaults.standard.set(
                Date(),
                forKey: k_CheckDateInited
            )
            UserDefaults.standard.synchronize()
            start()
        }
    }
}
