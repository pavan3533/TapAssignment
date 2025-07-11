//
//  Bond.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

struct BondListItem: Decodable {
    let logo: String
    let isin: String
    let rating: String
    let issuerName: String
    let tags: [String]

    private enum CodingKeys: String, CodingKey {
        case logo, isin, rating, tags
        case issuerName = "company_name"
    }
}
