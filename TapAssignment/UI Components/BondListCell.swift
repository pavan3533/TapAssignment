//
//  BondTableViewCell.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import UIKit

final class BondListCell: UITableViewCell {
    static let reuseID = "BondListCell"

    private let logoView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 4

        let hStack = UIStackView(arrangedSubviews: [logoView, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center

        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoView.layer.cornerRadius = 20
        logoView.clipsToBounds = true

        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: BondListItem, highlight searchText: String?) {
        titleLabel.attributedText = highlightMatches(
            in: item.issuerName,
            with: searchText
        )
        subtitleLabel.attributedText = highlightMatches(
            in: "\(item.isin) • Rating: \(item.rating)",
            with: searchText
        )

        if let url = URL(string: item.logo) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.logoView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    private func highlightMatches(in text: String, with searchText: String?) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        guard let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines),
              searchText.count >= 2 else {
            return attributed
        }

        let words = searchText.components(separatedBy: .whitespaces)
        for word in words where word.count >= 2 {
            let ranges = rangesOfSubstring(word, in: text.lowercased())
            for range in ranges {
                attributed.addAttribute(.backgroundColor, value: UIColor.yellow.withAlphaComponent(0.4), range: range)
                attributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize), range: range)
            }
        }

        return attributed
    }

    private func rangesOfSubstring(_ substring: String, in text: String) -> [NSRange] {
        let lowercasedText = text.lowercased()
        let substring = substring.lowercased()
        var ranges: [NSRange] = []

        var startIndex = lowercasedText.startIndex
        while let range = lowercasedText.range(of: substring, range: startIndex..<lowercasedText.endIndex) {
            let nsRange = NSRange(range, in: text)
            ranges.append(nsRange)
            startIndex = range.upperBound
        }

        return ranges
    }
}
