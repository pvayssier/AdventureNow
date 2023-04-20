//
//  WeatherForecastCell.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 12/04/2023.
//

import UIKit

class WeatherForecastCell: UITableViewCell {

    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    static let reuseIdentifier = String(describing: WeatherForecastCell.self)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getDayFromDate(from strDate: String) -> String {
        let strToDate = DateFormatter()
        strToDate.dateFormat = "yyyy-mm-dd"
        guard let date = Calendar.current.date(byAdding: .day, value: -1, to: strToDate.date(from: strDate) ?? Date())
        else { return "Date Error" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEEE"
        let dayString = dateFormatter.string(from: date)
        return dayString
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureUI()
    }

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textAlignment = .left
        label.font = UIFont(name: "Hiragino Sans W6", size: 15)
        label.textColor = UIColor(named: "textColor")
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textAlignment = .right
        label.font = UIFont(name: "Hiragino Sans W6", size: 15)
        label.textColor = UIColor(named: "textColor")
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func configureUI() {
        selectionStyle = .none
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(tempLabel)

        backgroundColor = .clear

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            dayLabel.rightAnchor.constraint(equalTo: contentView.leftAnchor, constant: 100),

            weatherImage.heightAnchor.constraint(equalToConstant: 35),
            weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 35),

            tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tempLabel.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: -100),
            tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30)
        ])
    }

    func configure(image: String, date: String, temperature: Double) {
        self.weatherImage.image = UIImage(named: image)
        self.dayLabel.text = getDayFromDate(from: date)
        self.tempLabel.text = String(round(temperature * 10) / 10)
    }

}
