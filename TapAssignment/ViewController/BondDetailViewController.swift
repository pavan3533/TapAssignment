//
//  BondDetailViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

final class BondDetailViewController: UIViewController {

    private let viewModel: BondDetailViewModel

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let logoView = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let statusLabel = UILabel()
    private let tabSwitcher = TabSwitcherView()

    private let chartView = BarChartView()
    private let prosConsLabel = UILabel()
    private let issuerDetailsStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground
        viewModel.delegate = self

        setupLayout()
        viewModel.loadDetail()
    }
    
    init(isin: String) {
        self.viewModel = BondDetailViewModel(isin: isin)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        logoView.contentMode = .scaleAspectFit
        logoView.layer.cornerRadius = 12
        logoView.clipsToBounds = true
        logoView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        nameLabel.font = .boldSystemFont(ofSize: 20)
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.numberOfLines = 0

        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .systemGreen

        tabSwitcher.delegate = self
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        prosConsLabel.font = .systemFont(ofSize: 14)
        prosConsLabel.numberOfLines = 0
        prosConsLabel.isHidden = true

        issuerDetailsStack.axis = .vertical
        issuerDetailsStack.spacing = 6
        issuerDetailsStack.isHidden = true

        // Add all views to content stack
        contentStack.addArrangedSubview(logoView)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(descLabel)
        contentStack.addArrangedSubview(statusLabel)
        contentStack.addArrangedSubview(tabSwitcher)
        contentStack.addArrangedSubview(chartView)
        contentStack.addArrangedSubview(prosConsLabel)
        contentStack.addArrangedSubview(issuerDetailsStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func renderDetail() {
        guard let detail = viewModel.bondDetail else { return }
        nameLabel.text = detail.companyName
        descLabel.text = detail.description
        statusLabel.text = detail.status

        if let url = URL(string: detail.logo) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.logoView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        updateTabs()
    }

    private func updateTabs() {
        showISINTab() // default
    }

    private func showISINTab() {
        chartView.monthlyData = viewModel.ebitdaData
        chartView.setNeedsDisplay()

        chartView.isHidden = false
        prosConsLabel.isHidden = true
        issuerDetailsStack.isHidden = false

        renderIssuerDetails()
    }

    private func showProsConsTab() {
        let pros = viewModel.pros.joined(separator: "\n• ")
        let cons = viewModel.cons.joined(separator: "\n• ")
        prosConsLabel.text = "✅ Pros:\n• \(pros)\n\n❌ Cons:\n• \(cons)"

        chartView.isHidden = true
        prosConsLabel.isHidden = false
        issuerDetailsStack.isHidden = true
    }

    private func renderIssuerDetails() {
        issuerDetailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let details = viewModel.bondDetail?.issuerDetails else { return }

        let add = { (title: String, value: String) in
            let label = UILabel()
            label.font = .systemFont(ofSize: 13)
            label.numberOfLines = 0
            label.text = "\(title): \(value)"
            self.issuerDetailsStack.addArrangedSubview(label)
        }

        add("Issuer Name", details.issuerName)
        add("Type of Issuer", details.typeOfIssuer)
        add("Sector", details.sector)
        add("Industry", details.industry)
        add("Issuer Nature", details.issuerNature)
        add("CIN", details.cin)
        add("Lead Manager", details.leadManager)
        add("Registrar", details.registrar)
        add("Debenture Trustee", details.debentureTrustee)
    }
}

// MARK: - Delegate Binding
extension BondDetailViewController: BondDetailViewModelDelegate {
    func didLoadBondDetail() {
        renderDetail()
    }

    func didFail(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Tab Switch
extension BondDetailViewController: TabSwitcherDelegate {
    func didSwitchToTab(index: Int) {
        if index == 0 {
            showISINTab()
        } else {
            showProsConsTab()
        }
    }
}
