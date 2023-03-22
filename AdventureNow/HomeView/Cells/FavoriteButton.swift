//
//  FavoriteButton.swift
//  AdventureNow
//
//  Created by Paul Vayssier on 22/03/2023.
//

import UIKit


final class FavoriteButton: UIButton {
    internal init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func makeFavoriteButton() {
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)

        var config = UIImage.SymbolConfiguration(font: font)
        config = config.applying(UIImage.SymbolConfiguration(hierarchicalColor: .black))

        let image = UIImage(
            systemName: "heart",
            withConfiguration: config)

        var buttonConf = UIButton.Configuration.plain()
        buttonConf.image = image

        self.configuration = buttonConf

        self.backgroundColor = .white.withAlphaComponent(0.8)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous

    }

}


