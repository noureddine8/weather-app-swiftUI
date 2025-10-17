//
//  WeatherServiceTests.swift
//  weatherly
//
//  Created by Noureddine Louafi on 17/10/2025.
//
import Foundation
import Testing
@testable import weatherly

struct WeatherServiceTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test("WeatherService returns weather on success")
    func testWeatherSuccess() async throws {
        let mockClient = MockNetworkClient(result: .success(Weather(current: CurrentWeather(temperature_2m: 23.5))))
        let service = WeatherService(networkClient: mockClient)

        let weather = try await service.getWeather()

        #expect(weather?.current.temperature_2m == 23.5)
    }
    
    @Test("WeatherService throws on decoding error")
    func testWeatherDecodingFailure() async {
        let mockClient = MockNetworkClient(result: .failure(NetworkError.decodingError(NSError(domain: "", code: 0))))
        let service = WeatherService(networkClient: mockClient)
        do {
            _ = try await service.getWeather()
            #expect(Bool(false), "Expected error, but got success")
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case .decodingError:
                    #expect(true)
                default:
                    #expect(Bool(false), "Expected `.decodingError`, got \(networkError)")
                }
            } else {
                #expect(Bool(false), "Expected a NetworkError, got \(type(of: error))")
            }
        }
    }
}
