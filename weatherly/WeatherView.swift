//
//  WeatherView.swift
//  weatherly
//
//  Created by noureddine on 6/10/2025.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var weatherService: WeatherService

    @State var weather: Weather?
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading...")
            } else if !errorMessage.isEmpty {
                Text(errorMessage).font(.headline)
            } else {
                Text(String(weather?.current.temperature_2m ?? 0))
                    .font(.title)
            }
        }
        .task {
            await fetchWeather()
        }
    }
    
    func fetchWeather() async {
        isLoading = true
        do {
            weather = try await weatherService.getWeather()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    WeatherView()
}
