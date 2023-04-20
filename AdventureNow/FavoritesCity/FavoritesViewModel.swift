//
//  FavoritesViewModel.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 09/04/2023.
//

import Foundation

final class FavoritesViewModel {

    init() {}

    // MARK: - Life Ciycle

    func viewDidAppear() {
        refreshFavorites()
    }

    // MARK: - Private Properties

    private(set) lazy var favoriteCities: [SuggestCity] = DestinationAPIService.shared.suggestedCities.filter( {$0.isFavorite == true})

    // MARK: - Private Methods

    func refreshFavorites() {
        favoriteCities = DestinationAPIService.shared.suggestedCities.filter( {$0.isFavorite == true})
    }

    // MARK: - Exposed Methods

    func removeFavoriteCity(at cityId: UUID) {
        if let index = DestinationAPIService.shared.suggestedCities.firstIndex(where: { $0.id == cityId }) {
            let city = DestinationAPIService.shared.suggestedCities[index]
            DestinationAPIService.shared.suggestedCities[index] = SuggestCity(
                apiID: city.apiID,
                image: city.cityImage,
                name: city.cityName,
                rate: Double(city.cityRate),
                latitude: city.latitude,
                longitude: city.longitude,
                isFavorite: false
            )
        }
        refreshFavorites()
    }

}
