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

    func viewDidAppear() {
        updateSuggestCity()
    }

    // MARK: - Private Properties

    private(set) lazy var suggestCity: [SuggestCity] = SuggestCity.all

    // MARK: - Private Methods

    private func updateSuggestCity() {
        suggestCity = SuggestCity.all
    }

    // MARK: - Exposed Methods

    func setFavoriteCity(_ favorite: SuggestCity) {
        if let index = SuggestCity.all.firstIndex(where: { $0.id == favorite.id }) {
            let city = suggestCity[index]
            if city.isFavorite {
                SuggestCity.all[index] = SuggestCity(
                    image: city.cityImage,
                    name: city.cityName,
                    rate: Float(city.cityRate),
                    isFavorite: false
                )
            } else {
                SuggestCity.all[index] = SuggestCity(
                    image: city.cityImage,
                    name: city.cityName,
                    rate: Float(city.cityRate),
                    isFavorite: true
                )
            }
            updateSuggestCity()
        }
    }

}
