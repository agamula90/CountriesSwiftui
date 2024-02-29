//
//  Result.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 28.02.2024.
//

import Foundation

enum Result<T> {
    case success(_ t: T)
    case error(error: NetworkError)
}
