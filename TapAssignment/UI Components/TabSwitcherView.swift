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

    weak var delegate: TabSwitcherDelegate?

    private let stackView = UIStackView()
    private let indicatorView = UIView()

    private let titles = ["ISIN Analysis", "Pros & Cons"]
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        indicatorView.backgroundColor = .label
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)

        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.tag = index
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40),

            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            indicatorView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    @objc private func tabTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index != selectedIndex else { return }
        selectedIndex = index
        updateIndicator(animated: true)
        delegate?.didSwitchToTab(index: index)
    }

    private func updateIndicator(animated: Bool) {
        let newLeading = CGFloat(selectedIndex) / CGFloat(titles.count)
        let indicatorX = bounds.width * newLeading

        UIView.animate(withDuration: animated ? 0.25 : 0.0) {
            self.indicatorView.frame.origin.x = indicatorX
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateIndicator(animated: false)
    }
}
