//
//  FullImageCell.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 11/04/2023.
//

import UIKit

class FullImageCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var cityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    static let reuseIdentifier = String(describing: FullImageCell.self)

    private func configureUI() {
        contentView.addSubview(cityImage)

        contentView.clipsToBounds = true
        backgroundColor = .clear
        contentView.layer.cornerRadius = 40
        selectionStyle = .none

        NSLayoutConstraint.activate([
            cityImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cityImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cityImage.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

    }

    func configure(city: SuggestCity) {
        cityImage.image = UIImage(named: city.cityImage)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
