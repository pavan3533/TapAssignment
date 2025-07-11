//
//  BondDetailViewModel.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

protocol BondDetailViewModelDelegate: AnyObject {
    func didLoadBondDetail()
    func didFail(_ error: String)
}

class BondDetailViewModel {

    weak var delegate: BondDetailViewModelDelegate?

    private(set) var bondDetail: BondDetail?

    func loadDetail() {
        BondDetailService().fetchBondDetail { [weak self] (result: Result<BondDetail, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.bondDetail = detail
                    self?.delegate?.didLoadBondDetail()
                case .failure(let error):
                    self?.delegate?.didFail(error.localizedDescription)
                }
            }
        }
    }

    var pros: [String] { bondDetail?.prosAndCons.pros ?? [] }
    var cons: [String] { bondDetail?.prosAndCons.cons ?? [] }
    var revenueData: [MonthlyData] { bondDetail?.financials.revenue ?? [] }
    var ebitdaData: [MonthlyData] { bondDetail?.financials.ebitda ?? [] }
}
