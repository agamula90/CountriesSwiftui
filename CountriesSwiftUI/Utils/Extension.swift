//
//  Utils.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 24.02.2024.
//

import Foundation

extension Int {
    var commaDelemitedPopulation: String {
        var result = ""
        var tempPopulation = self
        while(tempPopulation != 0) {
            let last3Digits = String(format: "%03d", tempPopulation % 1000)
            result = if(result == "") {
                last3Digits
            } else if tempPopulation < 1000 {
                "\(tempPopulation % 1000),\(result)"
            } else {
                "\(last3Digits),\(result)"
            }
            tempPopulation /= 1000
        }
        return result
    }
}

extension NetworkError {
    var description: String {
        let text: String
        
        switch (self) {
            case .badURL:
                text = "Bad url"
            case .jsonParsingError:
                text = "Parsing error"
            case let .networkError(code):
                text = "Network error with status code \(code)"
            case .unknown:
                text = "Unknown"
        }
        
        return text
    }
}
