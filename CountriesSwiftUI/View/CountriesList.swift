//
//  CountriesList.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 24.02.2024.
//

import SwiftUI

struct CountriesList: View {
    
    let countryRepository: CountryRepository
    
    @State private var countries: Array<Country> = []
    @State private var networkError: NetworkError?
    @State private var loaded: Bool = false
    
    var body: some View {
        if (!loaded) {
            Text("Loading")
                .onReceive(
                    countryRepository.getCountries()
                ) { countriesResult in
                    loaded = true
                    switch (countriesResult) {
                    case let .success(newCountries):
                        countries = newCountries
                        networkError = nil
                    case let .error(error):
                        networkError = error
                        countries = []
                    }
                }
        } else if let networkError {
            ErrorView(networkError: networkError)
        } else {
            NavigationStack {
                List(countries) { country in
                    NavigationLink {
                        CountryDetailsView(countryId: country.id, countryRepository: CountryRepositoryImpl())
                    } label: {
                        CountryRow(country: country)
                    }
                }
                .navigationTitle("Countries")
            }
        }
    }
}

#Preview {
    CountriesList(
        countryRepository: CountryRepositoryMocked()
    )
}
