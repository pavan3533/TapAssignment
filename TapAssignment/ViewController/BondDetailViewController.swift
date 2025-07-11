//
//  BondDetailViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

final class BondDetailViewController: UIViewController {

    private let viewModel = BondDetailViewModel()
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let logoView = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let tabSwitcher = TabSwitcherView()
    private let chartView = BarChartView()
    private let prosConsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = .systemBackground
        title = "Details"
        setupUI()
        viewModel.loadDetail()
    }

    private func setupUI() {
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
        descLabel.numberOfLines = 0
        descLabel.font = .systemFont(ofSize: 14)

        prosConsLabel.numberOfLines = 0
        prosConsLabel.font = .systemFont(ofSize: 14)

        tabSwitcher.delegate = self
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        contentStack.addArrangedSubview(logoView)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(descLabel)
        contentStack.addArrangedSubview(tabSwitcher)
        contentStack.addArrangedSubview(chartView)
        contentStack.addArrangedSubview(prosConsLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func renderDetail() {
        guard let detail = viewModel.bondDetail else { return }
        nameLabel.text = detail.companyName
        descLabel.text = detail.description
        if let url = URL(string: detail.logo) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.logoView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    private func showChart() {
        chartView.monthlyData = viewModel.ebitdaData
        chartView.setNeedsDisplay()
        chartView.isHidden = false
        prosConsLabel.isHidden = true
    }

    private func showProsCons() {
        let pros = viewModel.pros.joined(separator: "\n• ")
        let cons = viewModel.cons.joined(separator: "\n• ")
        prosConsLabel.text = "✅ Pros:\n• \(pros)\n\n❌ Cons:\n• \(cons)"
        chartView.isHidden = true
        prosConsLabel.isHidden = false
    }
}

// MARK: - Tab Switcher Delegate
extension BondDetailViewController: TabSwitcherDelegate {
    func didSwitchToTab(index: Int) {
        if index == 0 {
            showChart()
        } else {
            showProsCons()
        }
    }
}

// MARK: - ViewModel Delegate
extension BondDetailViewController: BondDetailViewModelDelegate {
    func didLoadBondDetail() {
        renderDetail()
        showChart() // default tab
    }

    func didFail(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
