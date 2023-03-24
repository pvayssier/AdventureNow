//
//  SuggestCityTableViewCell.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 21/03/2023.
//

import UIKit

final class SuggestCityTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    var favoriteButton: UIButton = FavoriteButton()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private lazy var backgroundImageView: UIImageView = {
        let fontScreenImageView = UIImageView()
        fontScreenImageView.layer.cornerCurve = .continuous
        fontScreenImageView.clipsToBounds = true
        fontScreenImageView.contentMode = .scaleAspectFill

        return fontScreenImageView
    }()

    private lazy var cityNameLabel: UILabel = {
        let name = UILabel()
        name.clipsToBounds = true
        name.textAlignment = .center
        name.layer.cornerRadius = 15
        name.layer.cornerCurve = .continuous
        name.contentMode = .scaleAspectFill
        name.backgroundColor = .white.withAlphaComponent(0.8)
        name.font = UIFont(name: "Hiragino Sans W6", size: 15)
        name.textColor = .black
        name.adjustsFontSizeToFitWidth = true

        return name
    }()

    private lazy var rateStackView: UIStackView = {

        var stackView = UIStackView()
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.clipsToBounds = true
        stackView.backgroundColor = .clear
        stackView.layer.cornerCurve = .continuous
        stackView.layer.cornerRadius = 10

        return stackView
    }()

    private lazy var cityRateContentView: UIView = {
        let view = UIView()
        rateStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rateStackView)

        view.clipsToBounds = true
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 10

        return view
    }()

    // MARK: - Private Methods

    private func makeStarsFrom(_ rate: Int) -> [UIImageView] {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12))

        let starFill = UIImage(systemName: "star.fill")?.applyingSymbolConfiguration(config)
        let star = UIImage(systemName: "star")?.applyingSymbolConfiguration(config)
        var test: [Int] = []
        var imageViews: [UIImageView] = (0..<rate).map { indice in
            test.append(indice)
            let imageView = UIImageView(image: starFill)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .black
            return imageView
        }
        imageViews.append(contentsOf: (0..<5-rate).map { indice in
            test.append(indice)
            let imageView = UIImageView(image: star)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .black
            return imageView
        })
        return imageViews
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityRateContentView.translatesAutoresizingMaskIntoConstraints = false
        rateStackView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(backgroundImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(cityRateContentView)
        contentView.addSubview(favoriteButton)

        contentView.clipsToBounds = true
        contentView.layer.cornerCurve = .continuous
        backgroundColor = .clear
        contentView.layer.cornerRadius = 40

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),

            cityNameLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            cityNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cityNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 70),
            cityNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70),

            cityRateContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cityRateContentView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            cityRateContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            cityRateContentView.widthAnchor.constraint(equalToConstant: 90),

            rateStackView.topAnchor.constraint(equalTo: cityRateContentView.topAnchor, constant: 0),
            rateStackView.bottomAnchor.constraint(equalTo: cityRateContentView.bottomAnchor, constant: 0),
            rateStackView.leftAnchor.constraint(equalTo: cityRateContentView.leftAnchor, constant: 5),
            rateStackView.widthAnchor.constraint(equalToConstant: 80),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 45),
            favoriteButton.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func toggleFavoriteButton(isFavorite: Bool) {
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        var config = UIImage.SymbolConfiguration(font: font)
        config = config.applying(UIImage.SymbolConfiguration(hierarchicalColor: .black))
        if isFavorite {
            favoriteButton.configuration?.image = UIImage(
                systemName: "heart.fill",
                withConfiguration: config
            )
        } else {
            favoriteButton.configuration?.image = UIImage(
                systemName: "heart",
                withConfiguration: config
            )
        }
    }

    // MARK: Exposed

    static let reuseIdentifier = String(describing: SuggestCityTableViewCell.self)

    func configure(image: String, name: String, rate: Int, isFavorite: Bool) {
        backgroundImageView.image = UIImage(named: image)
        cityNameLabel.text = name.uppercased()
        rateStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        rateStackView.addArrangedSubview(UIStackView(arrangedSubviews: makeStarsFrom(rate)))
        toggleFavoriteButton(isFavorite: isFavorite)
    }

}
