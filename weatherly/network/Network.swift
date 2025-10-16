//
//  Network.swift
//  weatherly
//
//  Created by Noureddine Louafi on 15/10/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case noData
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    case timeout
    case cancelled
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidRequest:
            return "Invalid request configuration"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received from server"
        case .httpError(let statusCode, _):
            return "HTTP Error: \(statusCode) - \(httpStatusMessage(for: statusCode))"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .timeout:
            return "Request timed out"
        case .cancelled:
            return "Request was cancelled"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    private func httpStatusMessage(for statusCode: Int) -> String {
        switch statusCode {
            case 400: return "Bad Request"
            case 401: return "Unauthorized"
            case 403: return "Forbidden"
            case 404: return "Not Found"
            case 500: return "Internal Server Error"
            case 502: return "Bad Gateway"
            case 503: return "Service Unavailable"
            default: return "Unknown Error"
        }
    }
}

protocol NetworkRequest {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var defaultHeaders: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var timeoutInterval: TimeInterval { get }
}

extension NetworkRequest {
    var baseURL: URL {
        URL(string: "https://api.open-meteo.com/")!
    }
    var defaultHeaders: [String: String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var timeoutInterval: TimeInterval { 30.0 }
}

protocol NetworkClientProtocol: Sendable {
    func perform<T: Decodable>(_ request: NetworkRequest) async throws -> T
}
