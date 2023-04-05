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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    func viewDidAppear() {
        super.viewDidAppear(true)
        configureUI()
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
            viewModel.setFavoriteCity(city)
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            SuggestCityTableViewCell.self,
            forCellReuseIdentifier: SuggestCityTableViewCell.reuseIdentifier
        )
        tableView.delaysContentTouches = false
        tableView.layer.cornerCurve = .continuous
        tableView.layer.cornerRadius = 40
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag

        return tableView
    }()

    private lazy var searchTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Rechercher"
//        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
//        textField.layer.cornerCurve = .continuous
//        textField.layer.cornerRadius = 15
//        textField.layer.borderWidth = 2
//        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 25))
//        textField.leftView = paddingView
//        textField.backgroundColor = tableView.backgroundColor
//        textField.leftViewMode = .always

        let searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: 36))

        // Ajout d'une marge à gauche pour la loupe
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        searchTextField.leftViewMode = .always

        // Configuration de l'icône de loupe
        let magnifyingGlass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlass.tintColor = .gray
        searchTextField.leftView?.addSubview(magnifyingGlass)
        magnifyingGlass.center = searchTextField.leftView!.center

        // Configuration du style de la bordure et du coin arrondi
        searchTextField.borderStyle = .roundedRect
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.masksToBounds = true

        // Configuration des couleurs de fond et de texte
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        searchTextField.textColor = .black

        // Configuration du placeholder
        searchTextField.placeholder = "Rechercher"

        return searchTextField
    }()

    // MARK: - Private Methods

    private func configureUI() {
        view.backgroundColor = UIColor(rgb: 0xf2ddbd)

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        view.addSubview(searchTextField)

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),

            searchTextField.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 30),
            searchTextField.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 60),
            searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150)
        ])
//        view.clipsToBounds = true
        navigationController?.navigationBar.isHidden = true
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
            isFavorite: city.isFavorite
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
