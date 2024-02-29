//
//  CountryDetailsViewModel.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 24.02.2024.
//

import Foundation

class CountryDetailsViewModel: ObservableObject {
    let countryRepository: CountryRepository
    
    @Published var country: CountryDetails?
    
    init(countryRepository: CountryRepository, country: CountryDetails? = nil) {
        self.countryRepository = countryRepository
        self.country = country
    }
    
    
    func getCountryDetails(countryId: String) {
        countryRepository.getCountry(countryId: countryId)
            .
    }
}
