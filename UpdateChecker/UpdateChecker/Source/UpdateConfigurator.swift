//
//  UpdateConfigurator.swift
//  UpdateChecker
//
//  Created by Vitaliy Podolskiy on 24.11.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

public struct UpdateConfigurator {
    private var bundleIdentifier: String
    
    @discardableResult
    public init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }
}
