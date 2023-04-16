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
    let longitude: Double
    let latitude: Double

    static var all: [SuggestCity] = [
        SuggestCity(image: "menton", name: "Menton", rate: 3.4, latitude: 43.7755103, longitude: 7.5029163),
        SuggestCity(image: "sainttropez", name: "Saint Tropez", rate: 4, latitude: 43.273177, longitude: 6.6396808),
        SuggestCity(image: "nice", name: "Nice", rate: 2.8, latitude: 43.6989315, longitude: 7.2723078),
        SuggestCity(image: "bordeaux", name: "Bordeaux", rate: 5, latitude: 48.9004739, longitude: 2.6724743)
    ]

    init(image: String, name: String, rate: Float, latitude: Double, longitude: Double) {
        self.cityName = name
        self.cityImage = image
        self.cityRate = Int(rate.rounded())
        self.longitude = longitude
        self.latitude = latitude
    }
}
