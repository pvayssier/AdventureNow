//
//  FavoritesCities+CoreDataProperties.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 19/04/2023.
//
//

import Foundation
import CoreData

extension FavoritesCities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesCities> {
        return NSFetchRequest<FavoritesCities>(entityName: "FavoritesCities")
    }

    @NSManaged public var apiID: String?
    @NSManaged public var isFavorite: Bool

}

extension FavoritesCities : Identifiable {

}
