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

protocol WeatherViewDelegate: AnyObject {
    func fetched(with weatherData: WeatherData)
    func error()
}

final class WeatherViewModel {
    private let networkManager = NetworkManager.shared
    weak var delegate: WeatherViewDelegate?
    
    private func getWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
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
    
    func buttonTapped(latitudeText: String?, longitudeText: String?) {
        guard let latitudeText = latitudeText,
              let longitudeText = longitudeText,
              let latitude = Double(latitudeText),
              let longitude = Double(longitudeText) else {
            return
        }
        
        getWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.delegate?.fetched(with: weatherData)
            case .failure(_):
                self?.delegate?.error()
                self?.delegate?.error()
            }
        }
    }
}
