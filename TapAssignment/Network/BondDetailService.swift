//
//  BondDetailService.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

class BondDetailService {
    static let shared = BondDetailService()

    private let url = "https://eo61q3zd4heiwke.m.pipedream.net"

    func fetchBondDetail(completion: @escaping (Result<BondDetail, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let detail = try JSONDecoder().decode(BondDetail.self, from: data)
                completion(.success(detail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
