//
//  Model.swift
//  EcoTracker App
//
//  Created by Mariam Mchedlidze on 30.11.23.
//

import Foundation

// MARK: - Welcome
struct WeatherData: Decodable {
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Decodable {
    let name: String
}

// MARK: - List
struct List: Decodable {
    let main: Main
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}

// MARK: - Main
struct Main: Decodable {
    let temp : Double
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let description : String
}
