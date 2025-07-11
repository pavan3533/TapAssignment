//
//  BondService.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

class BondService {

    static let shared = BondService()
    private let urlString = "https://eol122duf9sy4de.m.pipedream.net"

    func fetchBonds(completion: @escaping (Result<[Bond], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0)))
                return
            }

            do {
                let response = try JSONDecoder().decode(BondResponse.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
