//
//  CountryRow.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 24.02.2024.
//

import Foundation
import SwiftUI

struct CountryRow: View {
    var country: Country
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(country.name)
                .font(.title)
                .bold()
            Text("Population  \(country.population.commaDelemitedPopulation)")
                    .font(.caption)
        }
    }
}

#Preview {
    CountryRow(
        country: Country(
            id: "UA",
            name: "Ukraine",
            population: 38_000_000
        )
    )
}
