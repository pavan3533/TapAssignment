//
//  BondDetailViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

final class BondDetailViewController: UIViewController {
    private let isin: String
    private let service = BondDetailService()
    private var detail: BondDetail?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let logoView = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let tabSwitcher = TabSwitcherView()
    private let chartView = BarChartView()
    private let prosConsLabel = UILabel()

    init(isin: String) {
        self.isin = isin
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        setupUI()
        fetchDetail()
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

    private func fetchDetail() {
        service.fetchBondDetail { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.detail = detail
                    self?.render(detail: detail)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

    private func render(detail: BondDetail) {
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
        showChart()
    }

    private func showChart() {
        chartView.monthlyData = detail?.financials.ebitda ?? []
        chartView.setNeedsDisplay()
        chartView.isHidden = false
        prosConsLabel.isHidden = true
    }

    private func showProsCons() {
        let pros = detail?.prosAndCons.pros.joined(separator: "\n• ") ?? ""
        let cons = detail?.prosAndCons.cons.joined(separator: "\n• ") ?? ""
        prosConsLabel.text = "✅ Pros:\n• \(pros)\n\n❌ Cons:\n• \(cons)"
        chartView.isHidden = true
        prosConsLabel.isHidden = false
    }
}

extension BondDetailViewController: TabSwitcherDelegate {
    func didSwitchToTab(index: Int) {
        if index == 0 {
            showChart()
        } else {
            showProsCons()
        }
    }
}
