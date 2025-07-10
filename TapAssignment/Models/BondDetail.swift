//
//  BondDetail.swift
//  TapAssignment
//
//  Created by Pavan Javali on 10/07/25.
//

import Foundation

struct BondDetail: Codable {
    let logo: String
    let companyName: String
    let description: String
    let isin: String
    let status: String
    let prosAndCons: ProsAndCons
    let financials: Financials
    let issuerDetails: IssuerDetails

    enum CodingKeys: String, CodingKey {
        case logo
        case companyName = "company_name"
        case description
        case isin
        case status
        case prosAndCons = "pros_and_cons"
        case financials
        case issuerDetails = "issuer_details"
    }
}

struct ProsAndCons: Codable {
    let pros: [String]
    let cons: [String]
}

struct Financials: Codable {
    let ebitda: [MonthValue]
    let revenue: [MonthValue]
}

struct MonthValue: Codable {
    let month: String
    let value: Double
}

struct IssuerDetails: Codable {
    let issuerName: String
    let typeOfIssuer: String
    let sector: String
    let industry: String
    let issuerNature: String
    let cin: String
    let leadManager: String
    let registrar: String
    let debentureTrustee: String

    enum CodingKeys: String, CodingKey {
        case issuerName = "issuer_name"
        case typeOfIssuer = "type_of_issuer"
        case sector
        case industry
        case issuerNature = "issuer_nature"
        case cin
        case leadManager = "lead_manager"
        case registrar
        case debentureTrustee = "debenture_trustee"
    }
}
