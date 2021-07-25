//
//  LoadingView.swift
//  NextStats
//
//  Created by Jon Alaniz on 7/7/21.
//  Copyright © 2021 Jon Alaniz. All Rights Reserved.
//

import UIKit

class LoadingView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0

        return stackView
    }()

    private let activityIndicator = UIActivityIndicatorView()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 180).isActive = true
        label.text = .localized(.statsScreenFetchingData) // LocalizedKeys.statsScreenFetchingData
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .tertiaryLabel

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        activityIndicator.activate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
        activityIndicator.activate()
    }

    private func createSubviews() {
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(textLabel)

        addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
