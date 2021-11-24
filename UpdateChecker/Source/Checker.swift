//
//  Checker.swift
//  UpdateChecker
//
//  Created by Vitaliy Podolskiy on 24.11.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

public struct Checker {
    private var configuration: UpdateConfiguration
    
    public init(with configuration: UpdateConfiguration) {
        self.configuration = configuration
    }
    
    public func start() {
        assert(!configuration.bundleIdentifier.isEmpty)
        
        print(#function)
    }
}
