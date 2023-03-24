//
//  SuggestCityModel.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 20/03/2023.
//

import Foundation

struct SuggestCity {
    let id = UUID()
    let cityImage: String
    let cityName: String
    let cityRate: Int
    var isFavorite: Bool = false

    static var all: [SuggestCity] = [
        SuggestCity(image: "menton", name: "Menton", rate: 3.4, isFavorite: false),
        SuggestCity(image: "sainttropez", name: "Saint Tropez", rate: 4, isFavorite: true),
        SuggestCity(image: "nice", name: "Nice", rate: 2.8, isFavorite: false)
    ]

    init(image: String, name: String, rate: Float, isFavorite: Bool = false) {
        self.cityName = name
        self.cityImage = image
        self.cityRate = Int(rate.rounded())
        self.isFavorite = isFavorite
    }
}
