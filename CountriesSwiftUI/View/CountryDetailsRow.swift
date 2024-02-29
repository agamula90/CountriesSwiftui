//
//  CountryDetailsRow.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 29.02.2024.
//

import Foundation
import SwiftUI

struct CountryDetailsRow: View {
    
    let leftText: String
    let rightText: String
    
    init(leftText: String, rightText: String) {
        self.leftText = leftText
        self.rightText = rightText
    }
    
    var body: some View {
        HStack {
            Text(leftText).font(.headline)
            Spacer()
            Text(rightText).font(.callout)
        }
    }
}

#Preview {
    CountryDetailsRow(leftText: "Capital", rightText: "Kyiv")
}
