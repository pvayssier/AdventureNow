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

    private(set) static var all: [SuggestCity] = [
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




































// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass
    let included: [Included]
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: String
    let type: TypeEnum
    let attributes: DataAttributes
    let relationships: DataRelationships
}

// MARK: - DataAttributes
struct DataAttributes: Codable {
    let slug: String
    let url: String
    let destinationType, shortName, name, longName: String
    let population: Int
    let latitude, longitude: Double
    let boundingBox: String
    let geonamesID: Int
    let walkScoreURL: String
    let budget, safety: Budget
    let covid: String
    let averageRating: Double
    let checkInCount: Int
    let googleEventsURL, vrboURL, alltrailsURL, openElevationURL: String
    let foursquareURL, kayakCarRentalURL, kayakLodgingsURL, airbnbURL: String
    let getyourguideURL: String
    let wikipediaURL: String
    let woeID: Int
    let alternateNames: [String]
    let iso2, iso3, languages, currencyCode: String
    let currencyName, phonePrefix, capital: String
    let topCitiesAndTowns: [String]


}

// MARK: - Budget
struct Budget: Codable {
    let barcelonaSpain, spain: Spain

    enum CodingKeys: String, CodingKey {
        case barcelonaSpain = "Barcelona, Spain"
        case spain = "Spain"
    }
}

// MARK: - Spain
struct Spain: Codable {
    let value: Int
    let text, subText: String
}


// MARK: - CovidSpain
struct CovidSpain: Codable {
    let value: Double
    let url: String
    let text: String
}

// MARK: - DataRelationships
struct DataRelationships: Codable {
    let state, country, continent: Continent
    let knownFor, photos: KnownFor
    let travelers: Continent

    enum CodingKeys: String, CodingKey {
        case state, country, continent
        case knownFor = "known_for"
        case photos, travelers
    }
}

// MARK: - Continent
struct Continent: Codable {
    let data: DataUnion
}

enum DataUnion: Codable {
    case dat(DAT)
    case datArray([DAT])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([DAT].self) {
            self = .datArray(x)
            return
        }
        if let x = try? container.decode(DAT.self) {
            self = .dat(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(DataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DataUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dat(let x):
            try container.encode(x)
        case .datArray(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - DAT
struct DAT: Codable {
    let id: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case destination = "destination"
    case knownFor = "known_for"
    case photo = "photo"
    case user = "user"
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let data: [DAT]
}

// MARK: - Included
struct Included: Codable {
    let id: String
    let type: TypeEnum
    let attributes: IncludedAttributes
    let relationships: IncludedRelationships?
}

// MARK: - IncludedAttributes
struct IncludedAttributes: Codable {
    let slug, destinationType, shortName, name: String?
    let longName: String?
    let latitude, longitude: Double?
    let boundingBox: BoundingBox?
    let countable: Bool?
    let averageRating: Double?
    let checkInCount: Int?
    let image: Image?
    let icon, url: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case slug
        case destinationType = "destination_type"
        case shortName = "short_name"
        case name
        case longName = "long_name"
        case latitude, longitude
        case boundingBox = "bounding_box"
        case countable
        case averageRating = "average_rating"
        case checkInCount = "check_in_count"
        case image, icon, url
        case avatarURL = "avatar_url"
    }
}

// MARK: - BoundingBox
struct BoundingBox: Codable {
    let swLon, swLat, neLon, neLat: Double

    enum CodingKeys: String, CodingKey {
        case swLon = "sw_lon"
        case swLat = "sw_lat"
        case neLon = "ne_lon"
        case neLat = "ne_lat"
    }
}

// MARK: - Image
struct Image: Codable {
    let full, large, medium, thumb: String
    let avatar: String
}

// MARK: - IncludedRelationships
struct IncludedRelationships: Codable {
    let knownFor: KnownFor
    let featuredPhoto: Continent

    enum CodingKeys: String, CodingKey {
        case knownFor = "known_for"
        case featuredPhoto = "featured_photo"
    }
}
