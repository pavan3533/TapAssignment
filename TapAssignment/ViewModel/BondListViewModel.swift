//
//  BondListViewModel.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

protocol BondListViewModelDelegate: AnyObject {
    func didUpdateList()
    func didFailWithError(_ error: Error)
}

final class BondListViewModel {
    private let service = BondListService()
    private(set) var bonds: [BondListItem] = []
    weak var delegate: BondListViewModelDelegate?

    var searchQuery: String = "" {
        didSet {
            applySearchFilter()
        }
    }

    private var allBonds: [BondListItem] = []

    func fetchBonds() {
        service.fetchBondList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bonds):
                    self?.allBonds = bonds
                    self?.applySearchFilter()
                case .failure(let error):
                    self?.delegate?.didFailWithError(error)
                }
            }
        }
    }

    private func applySearchFilter() {
        if searchQuery.isEmpty {
            bonds = allBonds
        } else {
            bonds = allBonds.filter {
                $0.companyName.localizedCaseInsensitiveContains(searchQuery) ||
                $0.isin.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        delegate?.didUpdateList()
    }
}
