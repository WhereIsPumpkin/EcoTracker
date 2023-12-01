//
//  AirQualityViewModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import Foundation
import NetSwift

protocol AirQualityViewModelDelegate: AnyObject {
    
    func airQualityFetched(_ airQuality: [AirQualityModel])
    func showError(_ error: Error)
}

final class AirQualityViewModel {
    
    // MARK: - Properties
    private let baseURL = "https://api.weatherbit.io/v2.0/current/airquality?"
    private let apiKey =  "d55602ca1a8e4bc992bb93cc5fbf295c"
    
    weak var delegate: AirQualityViewModelDelegate?
    
    private var airQuality: [AirQualityModel]?
    
    // MARK: - Methods
    func fetchAirQuality(with cityName: String) {
        let urlStr = "\(baseURL)&city=\(cityName)&key=\(apiKey)"
        
        guard let url = URL(string: urlStr) else { return }
        
        NetworkManager.shared.fetchDecodableData(from: url, responseType: AirQualityResponse.self) { [weak self] (result: Result<AirQualityResponse, Error>) in
            switch result {
            case .success(let airQuality):
                self?.airQuality = airQuality.data
                self?.delegate?.airQualityFetched(airQuality.data)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func getConditionLabel(for airQualityIndex: Int) -> String {
        switch airQualityIndex {
        case 0..<100:
            return "HEALTHY"
        case 100..<201:
            return "UNHEALTHY"
        default:
            return "UNKNOWN"
        }
    }
    
    func getDescription(for airQualityIndex: Int) -> String {
        switch airQualityIndex {
        case 0..<100:
            return "Great news! The Air Quality Index (AQI) is in the healthy zone. It's like a gentle breeze of good air vibes, giving you the green light for all your outdoor adventures. Enjoy the day with confidence – whether it's a walk in the park, a bike ride, or just soaking up the sunshine. Keep the AQI in check, and revel in the joy of a breath-friendly atmosphere!"
        case 100..<201:
            return "When the Air Quality Index (AQI) signals an unhealthy environment, it's like a cautionary breeze in the air. Take a step back and consider shifting your plans indoors for a while. Opt for cozy indoor activities, whether it's binge-watching your favorite series, trying out a new recipe, or simply enjoying a good book. Keep an eye on the AQI updates – think of it as a temporary pause button for outdoor escapades. Safety first, and once the air quality improves, you can resume your adventures with a breath of relief!"
        default:
            return "The Air Quality Index (AQI) is like a weather report for the air we breathe. It measures how clean or polluted the air is and assigns a number from 0 to 500. The lower the number, the better the air quality – green is good! When the AQI is 0-50, it's all clear, and you can breathe easy. But as it climbs, especially into 151-200, it's a sign that the air quality is taking a turn for the worse. At 201-300, it's time to tread carefully – that's when the air might not be so friendly. And if it skyrockets to 301-500, it's a red alert – that air is as serious as it gets, and it's best to stay indoors until it clears up. Keep an eye on the AQI, and you'll know when it's a good day for a picnic or a cozy night in!"
        }
    }
}
