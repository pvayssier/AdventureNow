//
//  HomeViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 22/03/2023.
//
import Foundation

final class HomeViewModel {

    init() {}

    // MARK: - Life Ciycle

    func viewDidLoad() {
        fetchSuggestCity { city in
//            print(city)
        }
        updateSuggestCity()
    }

    func viewDidAppear() {
        updateSuggestCity()
    }

    // MARK: - Private Properties

    private(set) lazy var suggestCity: [SuggestCity] = SuggestCity.all

    // MARK: - Private Methods

    private func updateSuggestCity() {
        suggestCity = SuggestCity.all
    }

    private func getFavorites() -> [FavoriteCities] {
        return FavoriteCities.all
    }

    // MARK: - Exposed Methods

    func setFavoriteCity(_ favorite: SuggestCity) {
        if let index = SuggestCity.all.firstIndex(where: { $0.id == favorite.id }) {
            let city = suggestCity[index]
            if FavoriteCities.all.first(where: {$0.cityName == city.cityName}) != nil {
                FavoriteCities.all.append(FavoriteCities(
                    image: city.cityImage,
                    name: city.cityName,
                    rate: Float(city.cityRate),
                    latitude: city.latitude,
                    longitude: city.longitude
                ))
            } else {
                FavoriteCities.all = FavoriteCities.all.filter({$0.cityName != city.cityName})
            }
        }
    }

    func fetchSuggestCity(completionHandler: @escaping ([SuggestCity]?) -> Void) {
        let url = URL(string: "https://api.roadgoat.com/api/v2/destinations/7806954")!

        var request = URLRequest(url: url)
        let loginString = "3890b8185885d44193dd617dff841a5a:df6d21a9baf7d3e695ba1657ba47399b"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            guard response.statusCode == 200 else {
                print("Status code: \(response.statusCode)")
                return
            }
            if let dataString = String(data: data, encoding: .utf8) {
//                print(dataString)
            }
        }
        task.resume()
    }

}

struct APIResponse: Codable {
    let data: [Destination]
    let included: [Included]?
}

struct Destination: Codable {
    let id: String
    let type: String
    let attributes: DestinationAttribute
    let relationships: DestinationRelationship
}

struct DestinationAttribute: Codable {
    let slug: String
    let type: String
    let shortName: String
    let name: String
    let longName: String
    let latitude: Double
    let longitude: Double
    let boundingBox: String?
    let countable: Bool
    let averageRating: Double
    let checkInCount: Int
}

struct DestinationRelationship: Codable {
    let knownFor: KnownFor
    let featuredPhoto: FeaturedPhoto?
}

struct KnownFor: Codable {
    let data: [KnownForData]
}

struct KnownForData: Codable {
    let id: String
    let type: String
}

struct FeaturedPhoto: Codable {
    let data: FeaturedPhotoData?
}

struct FeaturedPhotoData: Codable {
    let id: String
    let type: String
}

struct Included: Codable {
    let id: String
    let type: String
    let attributes: IncludedAttribute?
}

struct IncludedAttribute: Codable {
    let image: Image
}

struct Image: Codable {
    let full: String
    let large: String
    let medium: String
    let thumb: String
    let avatar: String
}
