//
//  BondListViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import UIKit

final class BondListViewController: UIViewController {

    private let viewModel = BondListViewModel()

    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bonds"
        view.backgroundColor = .systemBackground
        viewModel.delegate = self

        setupUI()
        viewModel.fetchAll()
    }

    private func setupUI() {
        searchBar.placeholder = "Search bonds"
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BondListCell.self, forCellReuseIdentifier: BondListCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TableView
extension BondListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredBonds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bond = viewModel.filteredBonds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BondListCell.reuseID, for: indexPath) as! BondListCell
        cell.configure(with: bond)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bond = viewModel.filteredBonds[indexPath.row]
        let vc = BondDetailViewController(isin: bond.isin)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ViewModel Delegate
extension BondListViewController: BondListViewModelDelegate {
    func didUpdateList() {
        tableView.reloadData()
    }

    func didFail(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Search
extension BondListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(search: searchText)
    }
}
