//
//  APIManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/24/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// APIManager for Siren
public struct APIManager {
    /// Constants used in the `APIManager`.
    private struct Constants {
        /// Constant for the `bundleId` parameter in the iTunes Lookup API request.
        static let bundleID = "bundleId"
        /// Constant for the `country` parameter in the iTunes Lookup API request.
        static let country = "country"
        /// Constant for the `entity` parameter in the iTunes Lookup API reqeust.
        static let entity = "entity"
    }

    /// Return results or errors obtained from performing a version check with Siren.
    typealias CompletionHandler = (Result<APIModel, KnownError>) -> Void

    /// The default `APIManager`.
    ///
    /// The version check is performed against the  US App Store.
    public static let `default` = APIManager()
}

extension APIManager {
    /// Creates and performs a URLRequest against the iTunes Lookup API.
    ///
    /// - Parameter handler: The completion handler for the iTunes Lookup API request.
    func performVersionCheckRequest(configuration: UpdateConfiguration, completion handler: CompletionHandler?) {
        guard !configuration.bundleIdentifier.isEmpty else {
            handler?(.failure(.missingBundleID))
            return
        }

        do {
            let url = try makeITunesURL(configuration: configuration)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                URLCache.shared.removeCachedResponse(for: request)
                self.processVersionCheckResults(withData: data, response: response, error: error, completion: handler)
            }.resume()
        } catch {
            handler?(.failure(.malformedURL))
        }
    }

    /// Parses and maps the the results from the iTunes Lookup API request.
    ///
    /// - Parameters:
    ///   - data: The JSON data returned from the request.
    ///   - response: The response metadata returned from the request.
    ///   - error: The error returned from the request.
    ///   - handler: The completion handler to call once the results of the request has been processed.
    private func processVersionCheckResults(
        withData data: Data?,
        response: URLResponse?,
        error: Error?,
        completion handler: CompletionHandler?
    ) {
        if let error = error {
            handler?(.failure(.appStoreDataRetrievalFailure(underlyingError: error)))
        } else {
            guard let data = data else {
                handler?(.failure(.appStoreDataRetrievalFailure(underlyingError: nil)))
                return
            }
            do {
                let apiModel = try JSONDecoder().decode(APIModel.self, from: data)

                guard !apiModel.results.isEmpty else {
                    handler?(.failure(.appStoreDataRetrievalEmptyResults))
                    return
                }

                DispatchQueue.main.async {
                    handler?(.success(apiModel))
                }
            } catch {
                handler?(.failure(.appStoreJSONParsingFailure(underlyingError: error)))
            }
        }
    }

    /// Creates the URL that points to the iTunes Lookup API.
    ///
    /// - Returns: The iTunes Lookup API URL.
    /// - Throws: An error if the URL cannot be created.
    private func makeITunesURL(configuration: UpdateConfiguration) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        let items: [URLQueryItem] = [URLQueryItem(name: Constants.bundleID, value: configuration.bundleIdentifier)]

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw KnownError.malformedURL
        }

        return url
    }
}
