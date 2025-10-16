//
//  NetworkRequestStructs.swift
//  weatherly
//
//  Created by Noureddine Louafi on 14/10/2025.
//

import Foundation

struct GetUsersRequest: NetworkRequest {
    var path: String { "v1/forecast" }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "latitude", value: "52.52"),
            URLQueryItem(name: "longitude", value: "13.41"),
            URLQueryItem(name: "current", value: "temperature_2m")
        ]
    }
}
