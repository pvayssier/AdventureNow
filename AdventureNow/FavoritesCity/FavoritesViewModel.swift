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
        updateFavorites()
    }

    // MARK: - Private Properties

    private(set) lazy var favoriteCities: [SuggestCity] = SuggestCity.all

    // MARK: - Private Methods

    private func updateFavorites() {
        favoriteCities = SuggestCity.all
    }

    // MARK: - Exposed Methods

    func removeFavoriteCity(at cityId: UUID) {
        SuggestCity.all = favoriteCities.filter({$0.id != cityId})
    }

}
