//
//  BondListViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

import UIKit

class BondListViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel = BondListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bonds"
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchBonds()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BondTableViewCell.self, forCellReuseIdentifier: "BondCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension BondListViewController: BondListViewModelDelegate {
    func didLoadBonds() {
        tableView.reloadData()
    }

    func didFailWithError(_ message: String) {
        print("Error: \(message)")
        // Optional: show alert
    }
}

extension BondListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BondCell", for: indexPath) as! BondTableViewCell
        let bond = viewModel.bond(at: indexPath.row)
        cell.configure(with: bond)
        return cell
    }
}

