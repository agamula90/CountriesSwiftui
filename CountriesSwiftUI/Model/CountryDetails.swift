//
//  CountryDetails.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 26.02.2024.
//

import Foundation

struct CountryDetails {
    let name: String
    let flag: URL?
    let code: String
    let population: Int
    let capital: String
    let currency: Currency
    var neighbors: [Neighbor]
}

struct Currency {
    let symbol: String
    let description: String
    let name: String
}

struct Neighbor: Identifiable {
    let id: String
    let name: String
}
