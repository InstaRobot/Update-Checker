//
//  RulesManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// RulesManager for Siren
public struct RulesManager {
    /// Informs Siren of the type of update that is available so that
    /// the appropriate ruleset is used to present the update alert.
    ///
    /// - major: Major release available: A.b.c.d
    /// - minor: Minor release available: a.B.c.d
    /// - patch: Patch release available: a.b.C.d
    /// - revision: Revision release available: a.b.c.D
    /// - unknown: No information available about the update.
    public enum UpdateType: String {
        /// Major release available: A.b.c.d
        case major
        /// Minor release available: a.B.c.d
        case minor
        /// Patch release available: a.b.C.d
        case patch
        /// Revision release available: a.b.c.D
        case revision
        /// No information available about the update.
        case unknown
    }
}
