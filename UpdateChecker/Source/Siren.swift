//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// The Siren Class.
public final class Siren: NSObject {
    /// Return results or errors obtained from performing a version check with Siren.
    public typealias ResultsHandler = (Result<UpdateResults, KnownError>) -> Void

    /// The Siren singleton. The main point of entry to the Siren library.
    public static let shared = Siren()

    /// The manager that controls the App Store API that is
    /// used to fetch the latest version of the app.
    ///
    /// Defaults to the US App Store.
    public lazy var apiManager: APIManager = .default

    /// The current installed version of your app.
    lazy var currentInstalledVersion: String? = Bundle.version()

    /// The retained `NotificationCenter` observer that listens for `UIApplication.didBecomeActiveNotification` notifications.
    var applicationDidBecomeActiveObserver: NSObjectProtocol?

    /// The retained `NotificationCenter` observer that listens for `UIApplication.willResignActiveNotification` notifications.
    var applicationWillResignActiveObserver: NSObjectProtocol?

    /// The retained `NotificationCenter` observer that listens for `UIApplication.didEnterBackgroundNotification` notifications.
    var applicationDidEnterBackgroundObserver: NSObjectProtocol?

    /// The App Store's unique identifier for an app.
    private var appID: Int?

    /// The completion handler used to return the results or errors returned by Siren.
    private var resultsHandler: ResultsHandler?
}

// MARK: - Public API Interface

public extension Siren {
    /// This method executes the Siren version checking and alert presentation flow.
    ///
    /// - Parameters:
    ///   - handler: Returns the metadata around a successful version check and interaction with the update modal or it returns nil.
    func wail(completion handler: ResultsHandler? = nil) {
        resultsHandler = handler
        performVersionCheck()
    }

    /// Launches the AppStore in two situations when the user clicked the `Update` button in the UIAlertController modal.
    ///
    /// This function is marked `public` as a convenience for those developers who decide to build a custom alert modal
    /// instead of using Siren's prebuilt update alert.
    func launchAppStore() {
        guard let appID = appID,
            let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else {
                resultsHandler?(.failure(.malformedURL))
                return
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Version Check and Alert Presentation Flow

private extension Siren {
    /// Initiates the unidirectional version checking flow.
    func performVersionCheck() {
        apiManager.performVersionCheckRequest { result in
            switch result {
            case .success(let apiModel):
                self.validate(apiModel: apiModel)
            case .failure(let error):
                self.resultsHandler?(.failure(error))
            }
        }
    }

    /// Validates the parsed and mapped iTunes Lookup Model
    /// to guarantee all the relevant data was returned before
    /// attempting to present an alert.
    ///
    /// - Parameter apiModel: The iTunes Lookup Model.
    func validate(apiModel: APIModel) {
        // Check if the latest version is compatible with current device's version of iOS.
        guard DataParser.isUpdateCompatibleWithDeviceOS(for: apiModel) else {
            resultsHandler?(.failure(.appStoreOSVersionUnsupported))
            return
        }

        // Check and store the App ID .
        guard let results = apiModel.results.first,
            let appID = apiModel.results.first?.appID else {
            resultsHandler?(.failure(.appStoreAppIDFailure))
            return
        }
        self.appID = appID

        // Check and store the current App Store version.
        guard let currentAppStoreVersion = apiModel.results.first?.version else {
            resultsHandler?(.failure(.appStoreVersionArrayFailure))
            return
        }
        
        // Check the release date of the current version.
        guard let currentVersionReleaseDate = apiModel.results.first?.currentVersionReleaseDate else {
                resultsHandler?(.failure(.currentVersionReleaseDate))
                return
        }

        // Check if the App Store version is newer than the currently installed version.
        guard DataParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion,
                                                appStoreVersion: currentAppStoreVersion) else {
            resultsHandler?(.failure(.noUpdateAvailable))
            return
        }

        let model = Model(appID: appID,
                          currentVersionReleaseDate: currentVersionReleaseDate,
                          minimumOSVersion: results.minimumOSVersion,
                          releaseNotes: results.releaseNotes,
                          version: results.version)
        
        resultsHandler?(.success(UpdateResults(model: model)))
    }
}
