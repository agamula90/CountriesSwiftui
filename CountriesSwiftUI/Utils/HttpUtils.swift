//
//  HttpUtils.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 27.02.2024.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL(String)
    case networkError(Int)
    case jsonParsingError(DecodingError)
    case unknown
 }

// dataPublisher sends request to given URL and convert to Decodable Object
func dataPublisher<T: Decodable>(
    _ t: T.Type,
    with url: String
) -> AnyPublisher<Result<T>, Never> {
    
    // create the URL instance
    guard let requestURL = URL(string: url) else {
        return Fail<Result<T>, NetworkError>(error: NetworkError.badURL(url))
            .catch { error in
                Just(Result.error(error: error))
            }
            .eraseToAnyPublisher()
    }
    
    // create the session object
    let session = URLSession.shared
    
    // Now create the URLRequest object using the URL object
    let request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
    
    return session.dataTaskPublisher(for: requestURL)
        .tryMap { data, response in
            guard let code = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.unknown
            }
            if !(200 ..< 300).contains(code) {
                throw NetworkError.networkError(code)
            }
            
            return data
        }
        .decode(type: t, decoder: JSONDecoder())
        .tryMap { type in Result.success(type) }
        .catch { error -> Just<Result<T>> in
            let result: Just<Result<T>>
            if let decodingError = error as? DecodingError {
                result = Just(Result.error(error: .jsonParsingError(decodingError)))
            } else if let networkError = error as? NetworkError {
                result = Just(Result.error(error: networkError))
            } else {
                result = Just(Result.error(error: .unknown))
            }
            return result
        }
        .eraseToAnyPublisher()
}
