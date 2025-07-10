//
//  BondTableViewCell.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import UIKit

class BondTableViewCell: UITableViewCell {

    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let tagsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        logoImageView.contentMode = .scaleAspectFit
        nameLabel.font = .boldSystemFont(ofSize: 16)
        ratingLabel.font = .systemFont(ofSize: 14)
        tagsLabel.font = .systemFont(ofSize: 12)
        tagsLabel.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [nameLabel, ratingLabel, tagsLabel])
        stack.axis = .vertical
        stack.spacing = 4

        let hStack = UIStackView(arrangedSubviews: [logoImageView, stack])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center

        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with bond: Bond) {
        nameLabel.text = bond.companyName
        ratingLabel.text = "Rating: \(bond.rating)"
        tagsLabel.text = bond.tags.joined(separator: ", ")

        // Load logo
        if let url = URL(string: bond.logo) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.logoImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}

