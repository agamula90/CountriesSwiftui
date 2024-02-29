//
//  CountriesSwiftUIApp.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 14.02.2024.
//

import SwiftUI

@main
struct CountriesSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            CountriesList(countryRepository: CountryRepositoryImpl())
        }
    }
}
