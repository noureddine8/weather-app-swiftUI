//
//  weatherlyApp.swift
//  weatherly
//
//  Created by noureddine on 6/10/2025.
//

import SwiftUI

@main
struct weatherlyApp: App {
    private let weatherService = WeatherService(urlSessionNetworkClient: UrlSessionNetworkClient(baseURL: URL(string: "https://api.open-meteo.com/")!))
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherService)
        }
    }
}
