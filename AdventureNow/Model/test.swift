//
//  test.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 18/04/2023.
//

import UIKit
import CoreData

@objc(FavoritesCities)
public class FavoriteCity: NSManagedObject {
    @NSManaged public var apiID: String?
    @NSManaged public var isFavorite: Bool
}
