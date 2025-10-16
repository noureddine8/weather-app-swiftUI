//
//  WeatherlyApp.swift
//  weatherly
//
//  Created by noureddine on 6/10/2025.
//

import SwiftUI

@main
struct WeatherlyApp: App {
    private let weatherService = WeatherService(networkClient: UrlSessionClient())
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environmentObject(weatherService)
        }
    }
}
