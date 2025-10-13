//
//  Weather.swift
//  weatherly
//
//  Created by noureddine on 6/10/2025.
//

struct CurrentWeather: Decodable {
    let temperature_2m: Double
}


struct Weather: Decodable {
    let current : CurrentWeather
}
