//
//  FavCity.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 18/04/2023.
//

import Foundation

struct FavCities {
    let apiID: String
    let isFavorite: Bool
    init(apiID: String, isFavorite: Bool) {
        self.apiID = apiID
        self.isFavorite = isFavorite
    }
}
