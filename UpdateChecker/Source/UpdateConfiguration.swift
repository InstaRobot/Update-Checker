//
//  UpdateConfiguration.swift
//  UpdateChecker
//
//  Created by Vitaliy Podolskiy on 24.11.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

public struct UpdateConfiguration {
    private(set) var bundleIdentifier: String
    private(set) var daysBeforeCheck: Int
    
    public init(
        bundleIdentifier: String,
        daysBeforeCheck: Int = 0
    ) {
        self.bundleIdentifier = bundleIdentifier
        self.daysBeforeCheck  = daysBeforeCheck
    }
}
