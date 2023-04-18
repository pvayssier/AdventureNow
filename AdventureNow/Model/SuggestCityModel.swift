//
//  SuggestCityModel.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 20/03/2023.
//

import Foundation

struct SuggestCity {
    let id = UUID()
    let apiID: String
    let cityImage: String
    let cityName: String
    let cityRate: Int
    let latitude: Double
    let longitude: Double
    var isFavorite: Bool = false

    static var all: [SuggestCity] = []

    init(apiID: String, image: String, name: String, rate: Double, latitude: Double, longitude: Double) {
        self.apiID = apiID
        self.cityName = name
        self.cityImage = image
        self.cityRate = Int(rate.rounded())
        self.longitude = longitude
        self.latitude = latitude
    }
}
