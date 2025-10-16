//
//  WeatherService.swift
//  weatherly
//
//  Created by noureddine on 13/10/2025.
//

import Foundation

protocol WeatherServiceProtocol: Sendable {
    func getWeather() async throws -> Weather?
}

final class WeatherService: ObservableObject, WeatherServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getWeather() async throws -> Weather? {
        return try await networkClient.perform(GetUsersRequest())
    }
}
