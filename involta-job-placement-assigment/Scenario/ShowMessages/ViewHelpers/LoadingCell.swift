//
//  LoadingCell.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 09.05.2022.
//

import UIKit

class LoadingCell: UITableViewCell {

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        setupSpinner()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSpinner() {
        contentView.addSubview(spinner)

        let offset: CGFloat = 8

        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            spinner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            spinner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset),
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func startSpinnerAnimation() {
        spinner.startAnimating()
    }

}
