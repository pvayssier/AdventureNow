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
        getWeatherForecast(lat: city.latitude, long: city.longitude) { forecast in
            DispatchQueue.main.async {
                _ = forecast.compactMap { [weak self] (list) -> Void in
                    guard let self = self else { return }
                    if list.dtTxt.dropFirst(list.dtTxt.count-8) == "12:00:00" && self.threeDaysForecast.count < 3 {
                        self.threeDaysForecast.append(list)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    private let city: SuggestCity

    private func configureUI() {

        tableView.register(FullImageCell.self, forCellReuseIdentifier: FullImageCell.reuseIdentifier)
        tableView.register(CityMapCell.self, forCellReuseIdentifier: CityMapCell.reuseIdentifier)
        tableView.register(WeatherForecastCell.self, forCellReuseIdentifier: WeatherForecastCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(named: "backgroundColor")
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
            completionHandler: @escaping ([WeatherData]) -> Void
        ) {
            let key = "edadbe4fa6a2043def832d9375b43f8e"
            guard let url = URL(
    string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&units=metric&appid=\(key)"
            ) else {
                print(NSError(domain: "Invalid url", code: -1, userInfo: nil))
                return
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {
                    print(NSError(domain: "Invalid data", code: -1, userInfo: nil))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let response = try decoder.decode(WeatherDecodeModel.self, from: data)
                    let weatherData: [WeatherData] = response.list.map {
                        return WeatherData(temp: $0.main.temp, dtTxt: $0.dtTxt, icon: $0.weather[0].icon)
                    }
                    completionHandler(weatherData)
                } catch {
                    print(error)
                    return
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
                date: String(
                    threeDaysForecast[indexPath.row].dtTxt.dropLast(
                    threeDaysForecast[indexPath.row].dtTxt.count - 10)),
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

private struct WeatherData {
    let temp: Double
    let dtTxt: String
    let icon: String
}

private struct WeatherDecodeModel: Codable {
    let list: [List]
}

// MARK: - List
private struct List: Codable {
    let main: MainClass
    let weather: [Weather]
    let dtTxt: String

    private enum CodingKeys: String, CodingKey {
        case main
        case weather
        case dtTxt = "dt8_txt"
    }
}

private struct MainClass: Codable {
    let temp: Double
}

// MARK: - Weather
private struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
