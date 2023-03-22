//
//  HomeViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 22/03/2023.
//
import Foundation


final class HomeViewModel {

    init() {

    }

    // MARK: - Exposed Properties

    private(set) lazy var suggestCity: [SuggestCity] = SuggestCity.all

    // MARK: - Exposed Methods

    func viewDidAppear() {
        updateFavorites()
    }


    // MARK: - Private Properties

    

    // MARK: - Private Methods

    private func setFavoriteCity(_ favorite: SuggestCity, to value: Bool) {
        if let index = SuggestCity.all.firstIndex(where: { $0.id == favorite.id }) {
            let favCity = suggestCity[index]
            suggestCity[index] = SuggestCity(image: favCity.cityImage, name: favCity.cityName, rate: Float(favCity.cityRate), isFavorite: favCity.isFavorite)
            updateFavorites()
        }
    }

    private func updateFavorites() {
        suggestCity = SuggestCity.all
    }

}
