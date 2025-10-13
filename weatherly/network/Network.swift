//
//  Network.swift
//  weatherly
//
//  Created by noureddine on 13/10/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol NetworkRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

protocol NetworkClientProtocol {
    func perform<T: Decodable>(_ request: NetworkRequest) async throws -> T
}

final class UrlSessionNetworkClient: NetworkClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func perform<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        var components = URLComponents(url: baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false)
        components?.queryItems = request.queryItems
               
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
               
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
               
        let (data, response) = try await session.data(for: urlRequest)
               
        guard let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
               
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
