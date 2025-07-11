//
//  TabSwitcherView.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

protocol TabSwitcherDelegate: AnyObject {
    func didSwitchToTab(index: Int)
}

final class TabSwitcherView: UIView {
    private let titles = ["ISIN Analysis", "Pros & Cons"]
    private var buttons: [UIButton] = []
    private let indicator = UIView()
    weak var delegate: TabSwitcherDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabs()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabs() {
        backgroundColor = .secondarySystemBackground
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        for (i, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stack.addArrangedSubview(button)
        }

        addSubview(stack)
        addSubview(indicator)

        indicator.backgroundColor = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 2),
            indicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])
    }

    @objc private func tabTapped(_ sender: UIButton) {
        let index = sender.tag
        UIView.animate(withDuration: 0.25) {
            self.indicator.frame.origin.x = CGFloat(index) * (self.frame.width / 2)
        }
        delegate?.didSwitchToTab(index: index)
    }
}

