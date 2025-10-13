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
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 300)
            if isLoading {
                ProgressView("Loading...")
            } else {
                Text(String(weather?.current.temperature_2m ?? 0)).font(.title)
            }
        }
        .task {
            await getWeather()
        }
    }
    
    func getWeather() async {
        isLoading = true
        weather = await weatherService.getWeather()
        isLoading = false
    }
}

#Preview {
    WeatherView()
}
