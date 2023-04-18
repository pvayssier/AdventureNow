//
//  FavoritesTableViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 05/04/2023.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    internal init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func viewDidAppear() {
        super.viewDidAppear(true)
        viewModel.viewDidAppear()
        tableView.reloadData()
    }

    // MARK: - Private Properties

    private let viewModel: FavoritesViewModel

    // MARK: - Private Methods

    @objc
    private func didTapFavoriteButton(sender: FavoriteButton) {
        let point: CGPoint = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? FavoriteCitiesCell else { return }
        let button = sender
        if button == cell.favoriteButton {
            let cityId = cell.cityId
            viewModel.removeFavoriteCity(at: cityId)
            tableView.reloadData()
        }
    }

    private func configureUI() {
        tableView.register(
            FavoriteCitiesCell.self,
            forCellReuseIdentifier: FavoriteCitiesCell.reuseIdentifier
        )
        tableView.delaysContentTouches = false
        tableView.backgroundColor = UIColor(rgb: 0xf2ddbd)
    }

    // MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.favoriteCities.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteCitiesCell.reuseIdentifier
        ) as? FavoriteCitiesCell else {
            return UITableViewCell()
        }
        let city = viewModel.favoriteCities[indexPath.section]
        cell.configure(
            image: city.cityImage,
            name: city.cityName,
            rate: city.cityRate,
            id: city.id
        )

        cell.favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton(sender:)), for: .touchUpInside)

        return cell
    }

    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.favoriteCities[indexPath.section]
        let viewController = CityInformationTableViewController(city: city)
        viewController.navigationItem.title = city.cityName
        viewController.navigationController?.navigationBar.prefersLargeTitles = false
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

}
