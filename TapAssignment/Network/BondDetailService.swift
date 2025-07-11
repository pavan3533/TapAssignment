//
//  BondDetailService.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

final class BondDetailService {
    func fetchBondDetail(isin: String, completion: @escaping (Result<BondDetail, Error>) -> Void) {
        let fullURLString = "https://eo61q3zd4heiwke.m.pipedream.net?isin=\(isin)"
        guard let url = URL(string: fullURLString) else {
            completion(.failure(NSError(domain: "invalid_url", code: 400)))
            return
        }

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
