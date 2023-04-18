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
        updateSuggestCity()
    }

    func viewDidAppear() {
        updateSuggestCity()
    }

    // MARK: - Private Properties

    private(set) lazy var suggestCity: [SuggestCity] = SuggestCity.all

    // MARK: - Private Methods

    private func updateSuggestCity() {
        suggestCity = SuggestCity.all
    }

    private func getFavorites() -> [FavoriteCities] {
        return FavoriteCities.all
    }

    // MARK: - Exposed Methods

    func didTapFavoriteButton(_ favorite: SuggestCity) {
        if let index = SuggestCity.all.firstIndex(where: { $0.id == favorite.id }) {
            let city = suggestCity[index]
            if FavoriteCities.all.first(where: {$0.cityName == city.cityName}) != nil {
                FavoriteCities.all.append(FavoriteCities(
                    image: city.cityImage,
                    name: city.cityName,
                    rate: Float(city.cityRate),
                    latitude: city.latitude,
                    longitude: city.longitude
                ))
            } else {
                FavoriteCities.all = FavoriteCities.all.filter({$0.cityName != city.cityName})
            }
        }
    }
}
