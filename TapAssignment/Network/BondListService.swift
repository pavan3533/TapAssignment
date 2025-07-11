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
                let root = try JSONDecoder().decode([String: [BondListItem]].self, from: data)
                completion(.success(root["data"] ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
