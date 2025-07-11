//
//  BondListViewModel.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

protocol BondListViewModelDelegate: AnyObject {
    func didUpdateList()
    func didFail(_ error: String)
}

final class BondListViewModel {

    weak var delegate: BondListViewModelDelegate?

    private(set) var suggestedResults: [BondListItem] = []

    func fetchAll() {
        BondListService().fetchBondList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bonds):
                    self?.suggestedResults = bonds.filter {
                        $0.rating.uppercased() == "AAA" && $0.issuerName.localizedCaseInsensitiveContains("Hella")
                    }
                    self?.delegate?.didUpdateList()
                case .failure(let error):
                    self?.delegate?.didFail(error.localizedDescription)
                }
            }
        }
    }

    func filter(search: String) {
        if search.isEmpty {
            fetchAll()
        } else {
            suggestedResults = suggestedResults.filter {
                $0.issuerName.localizedCaseInsensitiveContains(search) ||
                $0.isin.localizedCaseInsensitiveContains(search)
            }
            delegate?.didUpdateList()
        }
    }
}
