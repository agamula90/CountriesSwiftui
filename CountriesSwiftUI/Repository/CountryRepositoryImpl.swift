//
//  CountryRepository.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 26.02.2024.
//

import Foundation
import Combine

protocol CountryRepository {
    func getCountries() -> AnyPublisher<Result<[Country]>, Never>
    func getCountry(countryId: String) -> AnyPublisher<Result<CountryDetails?>, Never>
}

class CountryRepositoryImpl: CountryRepository {
    private let baseUrl = "https://restcountries.com/v3.1"
    
    struct CountryDTO: Decodable {
        let name: CountryNameDTO
        let population: Int
        let cca3: String
    }
    
    struct CountryNameDTO: Decodable {
        let common: String
    }
    
    func getCountries() -> AnyPublisher<Result<[Country]>, Never> {
        return dataPublisher([CountryDTO].self, with: "\(baseUrl)/all?fields=name,population,cca3").map { countriesResult in
            let result: Result<[Country]>
            
            switch(countriesResult) {
                case let .error(error):
                    result = .error(error: error)
                case let .success(dto):
                    result = .success(
                        dto.map { country in
                            Country(id: country.cca3, name: country.name.common, population: country.population)
                        }
                    )
            }
            
            return result
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    struct CountryDetailsDTO: Decodable {
        let name: CountryNameDTO
        let flags: FlagsDTO
        let cca3: String
        let population: Int
        let capital: [String]
        let currencies: [String:CurrencyDTO]
        let borders: [String]?
    }
    
    struct FlagsDTO: Decodable {
        let png: String
    }
    
    struct CurrencyDTO: Decodable {
        let name: String
        let symbol: String
    }
    
    func getCountry(countryId: String) -> AnyPublisher<Result<CountryDetails?>, Never> {
        return dataPublisher([CountryDetailsDTO].self, with: "\(baseUrl)/alpha/\(countryId)").flatMap { countryResult in
            let result: AnyPublisher<Result<CountryDetails?>, Never>
            
            switch(countryResult) {
                case let .error(error):
                switch(error) {
                    case let .networkError(code):
                        if (code == 404) {
                            result = Just(.success(nil)).eraseToAnyPublisher()
                        } else {
                            result = Just(.error(error: error)).eraseToAnyPublisher()
                        }
                    default:
                        result = Just(.error(error: error)).eraseToAnyPublisher()
                    }
                case let .success(countries):
                    let country = countries[0]
                    var borders = country.borders ?? []
                    let currencyName = country.currencies.keys.first!
                    let currency = country.currencies[currencyName]!
                
                    var resultWithNeighbors: AnyPublisher<CountryDetails, Never> = Just(
                        CountryDetails(
                            name: country.name.common,
                            flag: URL(string: country.flags.png),
                            code: country.cca3,
                            population: country.population,
                            capital: country.capital[0],
                            currency: Currency(symbol: currency.symbol, description: currency.name, name: currencyName),
                            neighbors: []
                        )
                    ).eraseToAnyPublisher()
                    
                    while (!borders.isEmpty) {
                        let borderCountryId = borders.removeFirst()
                        resultWithNeighbors = resultWithNeighbors
                            .zip(self.getCountryName(countryId: borderCountryId))
                            .map {
                                let oldCountryDetails = $0
                                let country = $1!
                                var neighbors = oldCountryDetails.neighbors
                                neighbors.append(Neighbor(id: borderCountryId, name: country.name.common))
                            
                                return CountryDetails(
                                    name: oldCountryDetails.name,
                                    flag: oldCountryDetails.flag,
                                    code: oldCountryDetails.code,
                                    population: oldCountryDetails.population,
                                    capital: oldCountryDetails.capital,
                                    currency: oldCountryDetails.currency,
                                    neighbors: neighbors
                                )
                            }.eraseToAnyPublisher()
                    }
                result = resultWithNeighbors.map { .success($0) }.eraseToAnyPublisher()
            }
            
            return result
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getCountryName(countryId: String) -> AnyPublisher<CountryDTO?, Never> {
        return dataPublisher([CountryDTO].self, with: "\(baseUrl)/alpha/\(countryId)")
            .map { countryResult in
                let result: CountryDTO?
                
                switch(countryResult) {
                    case .error:
                        result = nil
                    case let .success(countries):
                        result = countries[0]
                }
                return result
            }
            .eraseToAnyPublisher()
    }
}

class CountryRepositoryMocked: CountryRepository {
    private let countries = [
        CountryDetails(
            name: "Ukraine", flag: URL(string: "https://flagcdn.com/w320/ua.png"), code: "UA",
            population: 39_000_000, capital: "Kyiv", currency: Currency(symbol: "₴", description: "Hryvnia", name: "UAH"), neighbors: [Neighbor(id: "POL", name: "Poland"), Neighbor(id: "ROU", name: "Romania")]
        ),
        CountryDetails(
            name: "Poland", flag: URL(string: "https://flagcdn.com/w320/pl.png"), code: "POL",
            population: 37_950_000, capital: "Warsaw", currency: Currency(symbol: "zł", description: "Złoty", name: "PLN"), neighbors: [Neighbor(id: "UA", name: "Ukraine"), Neighbor(id: "ROU", name: "Romania")]
        ),
        CountryDetails(
            name: "Romania", flag: URL(string: "https://flagcdn.com/w320/ro.png"), code: "ROU",
            population: 19_280_000, capital: "Bucharest", currency: Currency(symbol: "lei", description: "Leu", name: "RON"), neighbors: [Neighbor(id: "POL", name: "Poland"), Neighbor(id: "UA", name: "Ukraine")]
        ),
    ]
    
    func getCountries() -> AnyPublisher<Result<[Country]>, Never> {
        return Just(
            .success(
                countries.map { country in
                    Country(id: country.code, name: country.name, population: country.population)
                }
            )
        ).eraseToAnyPublisher()
    }
    
    func getCountry(countryId: String) -> AnyPublisher<Result<CountryDetails?>, Never> {
        return Just(
            .success(
                countries.first { country in country.code == countryId}
            )
        ).eraseToAnyPublisher()
    }
}
