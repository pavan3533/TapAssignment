//
//  BondListViewModel.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

protocol BondListViewModelDelegate: AnyObject {
    func didLoadBonds()
    func didFailWithError(_ message: String)
}

class BondListViewModel {

    weak var delegate: BondListViewModelDelegate?
    private(set) var bonds: [Bond] = []

    func fetchBonds() {
        BondService.shared.fetchBonds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bonds):
                    self?.bonds = bonds
                    self?.delegate?.didLoadBonds()
                case .failure(let error):
                    self?.delegate?.didFailWithError(error.localizedDescription)
                }
            }
        }
    }

    func bond(at index: Int) -> Bond {
        return bonds[index]
    }

    var count: Int {
        return bonds.count
    }
}

