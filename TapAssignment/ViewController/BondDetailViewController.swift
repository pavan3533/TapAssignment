//
//  BondDetailViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

class BondDetailViewController: UIViewController {

    private let viewModel = BondDetailViewModel()

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let prosLabel = UILabel()
    private let consLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        viewModel.delegate = self
        viewModel.loadDetail()
    }

    private func setupUI() {
        // Setup views (simplified)
        [titleLabel, descriptionLabel, prosLabel, consLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            prosLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            prosLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            consLabel.topAnchor.constraint(equalTo: prosLabel.bottomAnchor, constant: 20),
            consLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
}

extension BondDetailViewController: BondDetailViewModelDelegate {
    func didLoadBondDetail() {
        guard let detail = viewModel.bondDetail else { return }
        titleLabel.text = detail.companyName
        descriptionLabel.text = detail.description

        prosLabel.text = "Pros:\n" + viewModel.pros.joined(separator: "\n• ")
        consLabel.text = "Cons:\n" + viewModel.cons.joined(separator: "\n• ")
    }

    func didFail(_ error: String) {
        print("Failed to load detail:", error)
    }
}

