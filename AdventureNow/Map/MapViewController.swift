//
//  MapViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 29/03/2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    internal init(city: String) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let mapView = MKMapView()
    private var city: String

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        let closeButton = UIBarButtonItem(title: "Fermer", style: .done, target: self, action: #selector(closeMap))

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.navigationItem.leftBarButtonItem = closeButton

        configureMapView(cityName: city)
    }

    @objc private func closeMap() {
        self.dismiss(animated: true, completion: nil)
    }

    private func configureMapView(cityName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let placemark = placemarks?.first else { return }
            guard let self = self else { return }
            let location = placemark.location
            let coordinate = location?.coordinate ?? CLLocationCoordinate2D()
            let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: false)
        }
    }
}
