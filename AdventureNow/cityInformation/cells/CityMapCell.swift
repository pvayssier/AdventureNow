//
//  MapCell.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 11/04/2023.
//

import UIKit
import MapKit

class CityMapCell: UITableViewCell {

    static let reuseIdentifier = String(describing: CityMapCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mapView = MKMapView()

    private func configureUI() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapView)
        mapView.isUserInteractionEnabled = false

        contentView.clipsToBounds = true
        backgroundColor = .clear
        contentView.layer.cornerRadius = 40
        selectionStyle = .none

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
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

    func configure(cityName: String) {
        configureMapView(cityName: cityName)
    }
}
