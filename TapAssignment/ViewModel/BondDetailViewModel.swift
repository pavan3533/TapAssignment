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

final class BondDetailViewModel {

    weak var delegate: BondDetailViewModelDelegate?

    private let isin: String
    private(set) var bondDetail: BondDetail?

    init(isin: String) {
        self.isin = isin
    }

    func loadDetail() {
        BondDetailService().fetchBondDetail(isin: isin) { [weak self] result in
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
