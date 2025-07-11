//
//  BondDetailService.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

final class BondDetailService {
    private let url = URL(string: "https://eo61q3zd4heiwke.m.pipedream.net")!

    func fetchBondDetail(completion: @escaping (Result<BondDetail, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "data_nil", code: 1)))
                return
            }

            do {
                let detail = try JSONDecoder().decode(BondDetail.self, from: data)
                completion(.success(detail))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
