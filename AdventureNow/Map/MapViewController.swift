//
//  MapViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 29/03/2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let mapView = MKMapView()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureMapView()
    }



    func configureSearchController() {
        searchController.searchBar.delegate = self
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .systemBackground
            searchTextField.textColor = .systemFill
        }
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MapViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text else { return }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchQuery) { [weak self] (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let placemark = placemarks?.first else { return }
            guard let self = self else { return }
            let location = placemark.location
            let coordinate = location?.coordinate ?? CLLocationCoordinate2D()
            let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)

            let searchRequest = MKLocalSearch.Request()
            searchRequest.region = region
            searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant, .hotel, .museum])

            let search = MKLocalSearch(request: searchRequest)
            search.start(completionHandler: { (response, error) in
                guard let response = response else {
                print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    annotation.subtitle = mapItem.placemark.title
                    self.mapView.addAnnotation(annotation)
                }
            })
        }
    }
}

//private struct PointOfInterestStruct {
//    let restaurant = MKPointOfInterestCategory.restaurant
//    let hotel = MKPointOfInterestCategory.hotel
//    let museum = MKPointOfInterestCategory.museum
//}
