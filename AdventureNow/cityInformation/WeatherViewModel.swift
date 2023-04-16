////
////  WeatherViewModel.swift
////  AdventureNow
////
////  Created by Paul Vayssier on 16/04/2023.
////
//
//import Foundation
//
//final class WeatherViewModel {
//
//    init() {}
//
//    // MARK: - Life Ciycle
//
//    func viewDidLoad() {
//
//    }
//
//    func viewDidAppear() {
//
//    }
//
//    var threeDaysForecast: [ WeatherData ] = []
//
//    private func getWeatherForecast(latitude: Double, longitude: Double) {
//        fetchWeatherForecast(lat: latitude, long: longitude) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let forecast):
//                    forecast.compactMap { [weak self] (list) -> Void in
//                        guard let self = self else { return }
//                        if list.dt_txt.dropFirst(list.dt_txt.count-8) == "12:00:00" && self.threeDaysForecast.count < 3 {
//                            self.threeDaysForecast.append(list)
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }
//
//}
