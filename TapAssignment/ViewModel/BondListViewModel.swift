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

    private(set) var allBonds: [BondDetail] = []
    private(set) var filteredBonds: [BondDetail] = []

    func fetchAll() {
        BondDetailService().fetchBondDetail { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bond):
                    self?.allBonds = [bond] 
                    self?.filteredBonds = [bond]
                    self?.delegate?.didUpdateList()
                case .failure(let error):
                    self?.delegate?.didFail(error.localizedDescription)
                }
            }
        }
    }

    func filter(search: String) {
        if search.isEmpty {
            filteredBonds = allBonds
        } else {
            filteredBonds = allBonds.filter {
                $0.companyName.localizedCaseInsensitiveContains(search)
            }
        }
        delegate?.didUpdateList()
    }
}
