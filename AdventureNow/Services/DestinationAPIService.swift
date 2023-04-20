//
//  DestinationFetchService.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 18/04/2023.
//

import UIKit
import Network

class DestinationAPIService {

    private init() { }

    static let shared = DestinationAPIService()

    @Published private(set) var isLoading: Bool = false

    @Published private(set) var didHaveNetwork: Bool = true

    var suggestedCities = [SuggestCity]()

    func hasInternetConnection() {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
            semaphore.signal()
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        semaphore.wait()
        didHaveNetwork = isConnected
    }

    func fetchSuggestedCities(completionHandler: (() -> Void)? = nil) {
        hasInternetConnection()
        if didHaveNetwork {
            let fetchSuggestedCities: FetchSuggestedDestinations = FetchSuggestedDestinations()
            isLoading = true
            fetchSuggestedCities.fetchDestinations { [weak self] result in
                self?.suggestedCities = result ?? []
                self?.isLoading = false
            }
            completionHandler?()
        }
    }

    func testFetchSuggestedCities() {
        let fetchSuggestedCities: FetchSuggestedDestinations = FetchSuggestedDestinations()
        isLoading = true
        fetchSuggestedCities.fetchDestinations { [weak self] result in
            self?.suggestedCities = result ?? []
            self?.isLoading = false
        }
    }
}
