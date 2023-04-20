//
//  HomeViewController.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 23/03/2023.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    internal init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        configureUI()
        setupObservers()
        viewModel.viewDidLoad()
    }

    func viewDidAppear() {
        super.viewDidAppear(true)
        viewModel.viewDidAppear()
        tableView.reloadData()
    }

    // MARK: - Private Properties

    private let refreshControl = UIRefreshControl()

    private var loaderView: UIView?

    private let viewModel: HomeViewModel

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

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Private Methods

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

    private func configureUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    private func showAlert() {
        let alertController = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            DestinationAPIService.shared.hasInternetConnection()
            self?.didTapTryAgainButton()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    @objc private func refreshTableView() {
        viewDidLoad()
    }

    private func showLoadingView() {
        let loaderView = UIView(frame: UIScreen.main.bounds)
        loaderView.backgroundColor = .white
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = loaderView.center
        loaderView.addSubview(activityIndicator)
        view.addSubview(loaderView)
        loaderView.backgroundColor = UIColor(named: "backgroundColor")
        activityIndicator.startAnimating()

        self.loaderView = loaderView
    }

    private func hideLoadingView() {
        loaderView?.isHidden = true
        viewModel.refreshDestinations()
        tableView.reloadData()
    }

    @objc private func didTapTryAgainButton() {
        DestinationAPIService.shared.$didHaveNetwork.sink { [weak self] hasInternetConnection in
            if hasInternetConnection {
                self?.showLoadingView()
                DestinationAPIService.shared.testFetchSuggestedCities()
                self?.configureUI()
                self?.setupObservers()
                self?.viewModel.viewDidLoad()
            }
        }.store(in: &subscriptions)
    }

    private func setupObservers() {
        DestinationAPIService.shared.$didHaveNetwork.sink { [weak self] didHaveNetwork in
            if !didHaveNetwork {
                self?.showAlert()
            }
        }.store(in: &subscriptions)
        DestinationAPIService.shared.$isLoading.sink { [weak self] isLoading in
            isLoading ? self?.showLoadingView() : self?.hideLoadingView()
        }.store(in: &subscriptions)
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
            isFavorite: city.isFavorite,
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
