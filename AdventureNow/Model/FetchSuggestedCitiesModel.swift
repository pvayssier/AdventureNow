//
//  FetchSuggestedCitiesModel.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 17/04/2023.
//

import Foundation

class FetchSuggestedDestinations {

    func fetchDestinations(completionHandler: @escaping ([SuggestCity]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var destinations: [SuggestCity] = []

        fetchCountry { result in
            guard let cityIDs = result else {
                completionHandler(nil)
                return
            }

            let loginString = ""
            let loginData = loginString.data(using: .utf8)!
            let base64LoginString = loginData.base64EncodedString()

            for id in cityIDs {
                dispatchGroup.enter()

                let url = URL(string: "https://api.roadgoat.com/api/v2/destinations/\(id)")!
                var request = URLRequest(url: url)
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

                let task = URLSession.shared.dataTask(with: request) { (jsonData, response, error) in
                    defer {
                        dispatchGroup.leave()
                    }

                    guard let jsonData = jsonData, let response = response as? HTTPURLResponse, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    guard response.statusCode == 200 else {
                        print("Status code: \(response.statusCode)")
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(DestinationsResponse.self, from: jsonData)
                        let attributes = data.data.attributes

                        let city = SuggestCity(apiID: attributes.slug,
                                               image: attributes.shortName.lowercased(),
                                               name: attributes.shortName,
                                               rate: attributes.averageRating,
                                               latitude: attributes.latitude,
                                               longitude: attributes.longitude)
                        destinations.append(city)

                    } catch {
                        print(error)
                    }
                }
                task.resume()
            }

            dispatchGroup.notify(queue: .main) {
                completionHandler(destinations)
            }
        }
    }

    func fetchCountry(completionHandler: @escaping ([Int]?) -> Void) {
        let url = URL(string: "https://api.roadgoat.com/api/v2/destinations/france")!

        var request = URLRequest(url: url)
        let loginString = "3890b8185885d44193dd617dff841a5a:df6d21a9baf7d3e695ba1657ba47399b"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (jsonData, response, error) in
            guard let jsonData = jsonData, let response = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completionHandler(nil)
                return
            }
            guard response.statusCode == 200 else {
                print("Status code: \(response.statusCode)")
                completionHandler(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(CountryResponse.self, from: jsonData)
                let citiesIds = data.data.attributes.topCitiesAndTowns.map({ $0.id })
                completionHandler(citiesIds)
            } catch {
                print(error)
                completionHandler(nil)
            }
        }
        task.resume()
    }

}

private struct DestinationsResponse: Codable {
    let data: DestinationData
}

private struct DestinationData: Codable {
    let id: String
    let type: String
    let attributes: DestinationAttributes
//    let relationships: RelationShips
}

private struct DestinationAttributes: Codable {
    let slug: String
    let shortName: String
    let latitude: Double
    let longitude: Double
    let averageRating: Double

    private enum CodingKeys: String, CodingKey {
        case slug
        case shortName = "short_name"
        case latitude
        case longitude
        case averageRating = "average_rating"
    }
}

private struct RelationShips: Codable {
    let photos: DestinationPhotoData?
}

private struct DestinationPhotoData: Codable {
    let data: [DestinationPhotoId]
}

private struct DestinationPhotoId: Codable {
    let id: Int
}

private struct CountryResponse: Codable {
    let data: CountryData
}

private struct CountryData: Codable {
    let attributes: CountryAttributes
}

private struct CountryAttributes: Codable {
    let topCitiesAndTowns: [TopCity]

    private enum CodingKeys: String, CodingKey {
        case topCitiesAndTowns = "top_cities_and_towns"
    }
}

private struct TopCity: Codable {
    let id: Int
    let name: String
    let url: String
}
