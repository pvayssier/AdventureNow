//
//  CityInformationTableViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 11/04/2023.
//

import UIKit

class CityInformationTableViewController: UITableViewController {

    internal init(city: SuggestCity) {
        self.city = city
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var threeDaysForecast: [WeatherData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeatherForecast(lat: city.latitude, long: city.longitude) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    forecast.compactMap { [weak self] (list) -> Void in
                        guard let self = self else { return }
                        if list.dt_txt.dropFirst(list.dt_txt.count-8) == "12:00:00" && self.threeDaysForecast.count < 3 {
                            self.threeDaysForecast.append(list)
                        }
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    private let city: SuggestCity

    private func configureUI() {

        tableView.register(FullImageCell.self, forCellReuseIdentifier: FullImageCell.reuseIdentifier)
        tableView.register(CityMapCell.self, forCellReuseIdentifier: CityMapCell.reuseIdentifier)
        tableView.register(WeatherForecastCell.self, forCellReuseIdentifier: WeatherForecastCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(rgb: 0xf2ddbd)
        tableView.delaysContentTouches = false

        let closeButton = UIBarButtonItem(title: "Fermer", style: .done, target: self, action: #selector(closeMap))
        self.navigationItem.leftBarButtonItem = closeButton
    }

    @objc private func closeMap() {
        self.dismiss(animated: true, completion: nil)
    }

    private func getWeatherForecast(
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 3
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return 40
        case 2:
            return 250
        default:
            return 50
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FullImageCell.reuseIdentifier,
                for: indexPath) as? FullImageCell
            else { return UITableViewCell() }

            cell.configure(city: city)

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: WeatherForecastCell.reuseIdentifier,
                for: indexPath) as? WeatherForecastCell,
                  !threeDaysForecast.isEmpty
            else { return UITableViewCell() }
            cell.configure(
                image: threeDaysForecast[indexPath.row].icon,
                date: String(describing: threeDaysForecast[indexPath.row].dt_txt.dropLast(threeDaysForecast[indexPath.row].dt_txt.count - 10)),
                temperature: threeDaysForecast[indexPath.row].temp
            )

            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CityMapCell.reuseIdentifier,
                for: indexPath) as? CityMapCell
            else { return UITableViewCell() }

            cell.configure(cityName: city.cityName)

            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let viewController = MapViewController(city: city.cityName)
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
        }
    }

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


//struct WeatherResponse: Codable {
//    let cod: String?
//    let message: Int?
//    let cnt: Int?
//    let list: [WeatherForecast]
//    let city: String?
//    let country: String?
//}
//
//struct WeatherForecast: Codable { // swiftlint:disable identifier_name
//    let dt: TimeInterval?
//    let main: Main
//    let weather: [Weather]
//    let clouds: String?
//    let wind: Wind
//    let visibility: String?
//    let sys: String?
//    let dt_txt: String
//}
//
//struct Main: Codable {
//    let temp: Double
//    let feels_like: Double?
//    let temp_min: Double?
//    let temp_max: Double?
//    let pressure: Int?
//    let sea_level: Int?
//    let grnd_level: Int?
//    let humidity: Double?
//    let temp_kf: Double?
//}
//
//struct Weather: Codable {
//    let id: Int?
//    let main: String?
//    let description: String?
//    let icon: String
//}
//
//struct Wind: Codable {
//    let speed: Double?
//    let deg: Double?
//}
