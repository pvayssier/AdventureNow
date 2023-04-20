//
//  HomeViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 22/03/2023.
//
import Foundation

final class HomeViewModel {

    init() {}

    // MARK: - Life Ciycle

    func viewDidLoad() {
        refreshDestinations()
    }

    func viewDidAppear() {
        refreshDestinations()
    }

    // MARK: - Private Properties

    private(set) lazy var suggestCity: [SuggestCity] = DestinationAPIService.shared.suggestedCities

    // MARK: - Private Methods

    func refreshDestinations() {
        suggestCity = DestinationAPIService.shared.suggestedCities
    }

    private func getFavorites() -> [SuggestCity] {
        return DestinationAPIService.shared.suggestedCities.filter(\.isFavorite)
    }

    // MARK: - Exposed Methods

    func didTapFavoriteButton(_ favorite: SuggestCity) {
        if let index = DestinationAPIService.shared.suggestedCities.firstIndex(where: { $0.id == favorite.id }) {
            let city = suggestCity[index]
            if city.isFavorite {
                DestinationAPIService.shared.suggestedCities[index] = SuggestCity(
                    apiID: city.apiID,
                    image: city.cityImage,
                    name: city.cityName,
                    rate: Double(city.cityRate),
                    latitude: city.latitude,
                    longitude: city.longitude,
                    isFavorite: false
                )
            } else {
                DestinationAPIService.shared.suggestedCities[index] = SuggestCity(
                    apiID: city.apiID,
                    image: city.cityImage,
                    name: city.cityName,
                    rate: Double(city.cityRate),
                    latitude: city.latitude,
                    longitude: city.longitude,
                    isFavorite: true
                )
            }
        }
        refreshDestinations()
    }
}
