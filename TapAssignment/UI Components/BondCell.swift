//
//  BondTableViewCell.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import UIKit

final class BondListCell: UITableViewCell {
    static let reuseID = "BondListCell"

    private let nameLabel = UILabel()
    private let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stack = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .boldSystemFont(ofSize: 16)
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .secondaryLabel

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with bond: BondDetail) {
        nameLabel.text = bond.companyName
        statusLabel.text = bond.status
    }
}
