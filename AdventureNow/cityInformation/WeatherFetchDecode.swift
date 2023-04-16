//
//  WeatherFetchDecode.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 12/04/2023.
//

import Foundation

func fetchWeatherForecast(
    lat: Double,
    long: Double,
    completion: @escaping (Result<[WeatherData], Error>) -> Void
) {
    let key = ""
    guard let url = URL(
        string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&units=metric&appid=\(key)"
    ) else {
        completion(.failure(NSError(domain: "Invalid url", code: -1, userInfo: nil)))
        return
    }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "Invalid data", code: -1, userInfo: nil)))
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let response = try decoder.decode(Welcome7.self, from: data)
            let weatherData: [WeatherData] = response.list.map {
                return WeatherData(temp: $0.main.temp, dt_txt: $0.dt_txt, icon: $0.weather[0].icon)
            }
            completion(.success(weatherData))
        } catch {
            print(error)
            completion(.failure(error))
        }
    }
    task.resume()
}


struct WeatherData { // swiftlint:disable identifier_name
    let temp: Double
    let dt_txt: String
    let icon: String
}

struct Welcome7: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable { // swiftlint:disable identifier_name
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dt_txt: String
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feels_like, temp_min, temp_max: Double
    let pressure, sea_level, grnd_level, humidity: Int
    let temp_kf: Double
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double
    enum CodingKeys: String, CodingKey, Codable {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
