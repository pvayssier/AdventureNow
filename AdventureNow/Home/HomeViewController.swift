//
//  HomeViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 23/03/2023.
//

import UIKit

class HomeViewController: UIViewController {
    internal init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var loaderView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        viewModel.viewDidLoad()
        hideLoadingView()
        configureUI()
    }

    private func showLoadingView() {
        let loaderView = UIView(frame: UIScreen.main.bounds)
        loaderView.backgroundColor = .white
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = loaderView.center
        loaderView.addSubview(activityIndicator)
        view.addSubview(loaderView)
        activityIndicator.startAnimating()

        self.loaderView = loaderView
    }

    private func hideLoadingView() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }

    func viewDidAppear() {
        super.viewDidAppear(true)
        viewModel.viewDidAppear()
        tableView.reloadData()

    }

    // MARK: - Private Properties

    private let viewModel: HomeViewModel

    @objc
    private func didTapFavoriteButton(sender: FavoriteButton) {
        let point: CGPoint = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? SuggestCityTableViewCell else { return }
        let button = sender
        if button == cell.favoriteButton {
            let city = viewModel.suggestCity[indexPath.section]
            viewModel.didTapFavoriteButton(city)
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            SuggestCityTableViewCell.self,
            forCellReuseIdentifier: SuggestCityTableViewCell.reuseIdentifier
        )
        tableView.backgroundColor = view.backgroundColor
        tableView.delaysContentTouches = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag

        return tableView
    }()

    // MARK: - Private Methods

    private func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .done,
            target: self,
            action: #selector(didReloadDataButtonPressed)
        )

        self.navigationItem.rightBarButtonItem = closeButton

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

    }
    @objc private func didReloadDataButtonPressed() {
        viewModel.viewDidAppear()
        tableView.reloadData()
    }

}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.suggestCity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SuggestCityTableViewCell.reuseIdentifier
        ) as? SuggestCityTableViewCell else {
            return UITableViewCell()
        }
        let city = viewModel.suggestCity[indexPath.section]
        cell.configure(
            image: city.cityImage,
            name: city.cityName,
            rate: city.cityRate,
            isFavorite: false,
            id: city.id
        )

        cell.favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton(sender:)), for: .touchUpInside)

        return cell
    }

}

// MARK: - TableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.suggestCity[indexPath.section]
        let viewController = CityInformationTableViewController(city: city)
        viewController.navigationItem.title = city.cityName
        viewController.navigationController?.navigationBar.prefersLargeTitles = false
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, opacity: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: opacity
        )
    }

    convenience init(rgb: Int, opacity: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            opacity: opacity
        )
    }
}
