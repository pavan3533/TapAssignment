//
//  BondService.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

final class BondListService {
    private let url = URL(string: "https://eol122duf9sy4de.m.pipedream.net")!

    func fetchBondList(completion: @escaping (Result<[BondListItem], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "data_nil", code: 1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                completion(.success(decoded.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

private struct ResponseWrapper: Decodable {
    let data: [BondListItem]
}

