//
//  MessageCell.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 11.05.2022.
//

import UIKit

class MessageCell: UITableViewCell {

    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.messageLabel.preferredMaxLayoutWidth = self.messageLabel.frame.size.width
    }

    private func setupLayout() {
        contentView.addSubview(messageLabel)
        let offset: CGFloat = 8

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ])

    }
}
