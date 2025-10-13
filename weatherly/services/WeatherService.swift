//
//  WeatherService.swift
//  weatherly
//
//  Created by noureddine on 13/10/2025.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeather() async -> Weather?
}

class WeatherService: ObservableObject, WeatherServiceProtocol {
    private let urlSessionNetworkClient: NetworkClientProtocol

    
    init(urlSessionNetworkClient: NetworkClientProtocol) {
        self.urlSessionNetworkClient = urlSessionNetworkClient
    }
    
    func getWeather() async -> Weather? {
        struct GetUsersRequest: NetworkRequest {
            var path: String { "v1/forecast" }
            var method: HTTPMethod { .get }
            var headers: [String: String]? { nil }
            var body: Data? { nil }
            var queryItems: [URLQueryItem]? {
                [
                    URLQueryItem(name: "latitude", value: "52.52"),
                    URLQueryItem(name: "longitude", value: "13.41"),
                    URLQueryItem(name: "current", value: "temperature_2m")
                ]
            }
        }
        do {
            return try await urlSessionNetworkClient.perform(GetUsersRequest())
        } catch {
            return nil
        }
    }
}

actor Counter {
    var value = 0
    
    func increment() {
        value += 1
    }
}

func testRace() async {
    let counter = Counter()
    
    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<10 {
            group.addTask {
                await counter.increment()
            }
        }
    }
}
