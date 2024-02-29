//
//  Countrydetail.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 24.02.2024.
//

import SwiftUI

struct CountryDetailsView: View {
    let countryId: String
    let countryRepository: CountryRepository
    
    @State private var countryDetails: CountryDetails?
    @State private var networkError: NetworkError?
    @State private var loaded: Bool = false
    
    var body: some View {
        if (!loaded) {
            Text("Loading").onReceive(countryRepository.getCountry(countryId: countryId)) { countryDetailsResult in
                loaded = true
                switch (countryDetailsResult) {
                    case let .success(newCountryDetails):
                        countryDetails = newCountryDetails
                        networkError = nil
                    case let .error(error):
                        networkError = error
                        countryDetails = nil
                }
            }
        } else if let networkError {
            ErrorView(networkError: networkError)
        } else if let countryDetails {
            NavigationStack {
                List {
                    HStack {
                        Spacer()
                        FlagView(flagUrl: countryDetails.flag)
                        Spacer()
                    }
                    Section("Basic info") {
                        CountryDetailsRow(leftText: "Code", rightText: countryDetails.code)
                        CountryDetailsRow(leftText: "Population", rightText: countryDetails.population.commaDelemitedPopulation)
                        CountryDetailsRow(leftText: "Capital", rightText: countryDetails.capital)
                    }
                    Section("Currencies") {
                        let currency = countryDetails.currency
                        CountryDetailsRow(
                            leftText: "\(currency.description) \(currency.symbol)",
                            rightText: currency.name
                        )
                    }
                    Section("Neighboring countries") {
                        ForEach(countryDetails.neighbors) { country in
                            NavigationLink(destination: self.NeighbourDetailsView(countryId: country.id)) {
                                Text(country.name).font(.title)
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle(countryDetails.name)
            }
        }
    }
    
    func FlagView(flagUrl: URL?) -> some View {
        AsyncImage(url: flagUrl) { image in
            if let image = image.image {
                image
                    .resizable()
                    .frame(width: 120, height: 80)
                    .aspectRatio(contentMode: .fill)
            } else if image.error != nil {
                Color(Color.red)
            } else {
                Color(Color.gray)
            }
        }.frame(width: 120, height: 80)
    }
    
    func NeighbourDetailsView(countryId: String) -> some View {
        CountryDetailsView(countryId: countryId, countryRepository: countryRepository)
    }
}

#Preview {
    CountryDetailsView(countryId: "UA", countryRepository: CountryRepositoryMocked())
}
