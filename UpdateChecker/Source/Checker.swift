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
        
        if let date = UserDefaults.standard.object(forKey: k_CheckDateInited) as? Date {
            print(date)
        }
        else {
            UserDefaults.standard.set(
                Date(),
                forKey: k_CheckDateInited
            )
            UserDefaults.standard.synchronize()
            start()
        }
        
        print(#function)
    }
}
