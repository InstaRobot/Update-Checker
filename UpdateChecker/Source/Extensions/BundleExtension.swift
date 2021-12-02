//
//  BundleExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// `Bundle` Extension for Siren.
extension Bundle {
    /// Constants used in the `Bundle` extension.
    struct Constants {
        static let bundleExtension = "bundle"
        static let displayName = "CFBundleDisplayName"
        static let shortVersionString = "CFBundleShortVersionString"
    }

    /// Fetches the current version of the app.
    ///
    /// - Returns: The current installed version of the app.
    final class func version() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: Constants.shortVersionString) as? String
    }
}
