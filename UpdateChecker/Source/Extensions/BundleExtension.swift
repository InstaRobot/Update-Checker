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
        static let englishLocalization = "en"
        static let projectExtension = "lproj"
        static let shortVersionString = "CFBundleShortVersionString"
    }

    /// Fetches the current version of the app.
    ///
    /// - Returns: The current installed version of the app.
    final class func version() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: Constants.shortVersionString) as? String
    }

    /// The appropriate name for the app to be displayed in the update alert.
    ///
    /// Siren checks `CFBundleDisplayName` first. It then falls back to
    /// to `kCFBundleNameKey` and ultimately to an empty string
    /// if the aforementioned values are nil.
    ///
    /// - Returns: The name of the app.
    final class func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: Constants.displayName) as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        return bundleDisplayName ?? bundleName ?? ""
    }
}
