//
//  Bond.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

struct BondResponse: Codable {
    let data: [Bond]
}

struct Bond: Codable {
    let logo: String
    let isin: String
    let rating: String
    let companyName: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case logo
        case isin
        case rating
        case companyName = "company_name"
        case tags
    }
}
