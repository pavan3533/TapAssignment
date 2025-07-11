//
//  BondTableViewCell.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import UIKit

final class BondCell: UITableViewCell {
    static let reuseID = "BondCell"

    private let logoView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let isinLabel = UILabel()
    private let companyLabel = UILabel()
    private let ratingLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with bond: BondListItem) {
        isinLabel.text = bond.isin
        companyLabel.text = "\(bond.rating) • \(bond.companyName)"
        ratingLabel.text = bond.rating

        if let url = URL(string: bond.logo) {
            // Simple image fetch (replace with SDWebImage if needed)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.logoView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    private func setUpUI() {
        let stack = UIStackView(arrangedSubviews: [isinLabel, companyLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(logoView)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 40),
            logoView.heightAnchor.constraint(equalToConstant: 40),

            stack.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
