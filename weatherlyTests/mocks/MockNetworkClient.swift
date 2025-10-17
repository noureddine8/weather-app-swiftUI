//
//  MockNetworkClient.swift
//  weatherly
//
//  Created by Noureddine Louafi on 17/10/2025.
//

import XCTest
@testable import weatherly

final class MockNetworkClient: NetworkClientProtocol {
    
    let result: Result<Weather, Error>?
    
    init(result: Result<Weather, Error>?) {
        self.result = result
    }
    func perform<T>(_ request: NetworkRequest) async throws -> T where T : Decodable {
        switch result {
        case .success(let value):
            guard let typedValue = value as? T else {
                throw NetworkError.decodingError(NSError(domain: "", code: 0, userInfo: nil))
            }
            return typedValue
        case .failure(let error):
            throw error
        }
    }
}
