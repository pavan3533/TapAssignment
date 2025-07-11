//
//  BondListViewController.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import UIKit

final class BondListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = BondListViewModel()

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search by Issuer Name or ISIN"
        sb.delegate = self
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemGroupedBackground
        setUpTable()
        viewModel.delegate = self
        viewModel.fetchBonds()
    }

    private func setUpTable() {
        tableView.register(BondCell.self, forCellReuseIdentifier: BondCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension BondListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
}

extension BondListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bonds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BondCell.reuseID, for: indexPath) as? BondCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.bonds[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel.bonds[indexPath.row]
        let detailVC = BondDetailViewController(isin: selected.isin)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BondListViewController: BondListViewModelDelegate {
    func didUpdateList() {
        tableView.reloadData()
    }

    func didFailWithError(_ error: Error) {
        // You can show an alert
        print("Error loading bonds: \(error.localizedDescription)")
    }
}

