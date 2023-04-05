//
//  TabBarItem.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 23/03/2023.
//

import Foundation

import UIKit

enum TabItem: Int, CaseIterable {
    case home
    case prepareTrip
    case map

    var navigationController: UINavigationController {
        switch self {
        case .home:
            return makeNavigationViewController(
                rootViewController: HomeViewController(viewModel: HomeViewModel())
            )
        case .prepareTrip:
            return makeNavigationViewController(
                rootViewController: PrepareTripViewController()
            )
        case .map:
            return makeNavigationViewController(
                rootViewController: MapViewController()
            )
        }
    }

    var image: UIImage? {
        switch self {
        case .home:     return UIImage(systemName: "building.2.crop.circle.fill")
        case .prepareTrip:      return UIImage(systemName: "house.circle")
        case .map:      return UIImage(systemName: "map.fill")
        }
    }

    private func makeNavigationViewController(
        rootViewController: UIViewController
    ) -> UINavigationController {
        let navVC = UINavigationController(
            rootViewController: rootViewController
        )
        navVC.tabBarItem = UITabBarItem(title: "", image: image, tag: rawValue)
        return navVC
    }
}
