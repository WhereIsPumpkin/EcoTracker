//
//  WeatherViewModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//
// WeatherViewModel.swift
// WeatherViewModel.swift

import NetSwift
import Foundation

class WeatherViewModel {
    private let networkManager = NetworkManager.shared

    func getWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let apiKey = "8d75024f90b7aa88dcfbf11ab71ffaab"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkManager.NetworkError.noData))
            return
        }
        networkManager.fetchDecodableData(from: url, responseType: WeatherData.self) { result in
            completion(result)
        }
    }
}


