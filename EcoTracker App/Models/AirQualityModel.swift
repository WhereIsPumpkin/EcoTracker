//
//  AirQualityModel.swift
//  EcoTracker App
//
//  Created by Anna Sumire on 01.12.23.
//

import Foundation

// MARK: - AirQualityResponse
struct AirQualityResponse: Decodable {
    let data: [AirQualityModel]
}

// MARK: - AirQualityModel
struct AirQualityModel: Decodable {
    let airQuality: Int
    
    enum CodingKeys: String, CodingKey {
        case airQuality = "aqi"
    }
}
