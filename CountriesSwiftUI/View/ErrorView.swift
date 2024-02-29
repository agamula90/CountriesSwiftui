//
//  ErrorView.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 29.02.2024.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    
    let networkError: NetworkError
    
    var body: some View {
        Text(networkError.description).font(.subheadline)
    }
}

#Preview {
    ErrorView(networkError: .networkError(400))
}
