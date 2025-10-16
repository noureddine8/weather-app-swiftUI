//
//  Network.swift
//  weatherly
//
//  Created by noureddine on 13/10/2025.
//

import Foundation
import ResponseDetective

final class UrlSessionClient: NetworkClientProtocol {
    private let urlSession: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        ResponseDetective.enable(inConfiguration: configuration)
        urlSession = URLSession(configuration: configuration)
    }
    
    func perform<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        
        let urlRequest = try constructRequest(request)
        
        let (data, response) = try await performRequest(urlRequest)
        
        try validateResponse(response, data: data)
        
        let decoded = try decode(T.self, from: data)
        
        return decoded
    }
    
    private func constructRequest(_ request: NetworkRequest) throws -> URLRequest {
        var components = URLComponents(url: request.baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false)
        components?.queryItems = request.queryItems
        guard let url = components?.url else { throw URLError(.badURL) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.defaultHeaders
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields?.merge(headers) { current, new in new }
        }
        urlRequest.httpBody = request.body
        return urlRequest
    }
    
    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await urlSession.data(for: request)
            return (data, response)
        } catch let error as URLError {
            throw mapURLError(error)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                return .networkError(error)
        }
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
            
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
