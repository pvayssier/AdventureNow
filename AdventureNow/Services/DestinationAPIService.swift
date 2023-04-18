//
//  DestinationFetchService.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 18/04/2023.
//

import Foundation

class DestinationAPIService {

    static let shared = DestinationAPIService()

    func fetch(completionHalder: @escaping () -> Void) {
        let fetchSuggestedCities: FetchSuggestedDestinations = FetchSuggestedDestinations()
        fetchSuggestedCities.fetchDestinations { result in
            guard let result else { return }
            _ = result.map { suggestCity in
                SuggestCity.all.append(suggestCity)
                print(SuggestCity.all.count)
            }
        }
        completionHalder()
    }
}
