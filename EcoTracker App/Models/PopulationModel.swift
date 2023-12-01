//
//  PopulationModel.swift
//  EcoTracker App
//
//  Created by Lika Nozadze on 11/30/23.
//

import Foundation

struct CountryList: Decodable {
    let countries: [String]
}

struct TotalPopulation: Decodable {
    let totalPopulation: [Population]
    
    enum CodingKeys: String, CodingKey {
        case totalPopulation = "total_population"
    }
    struct Population: Decodable {
        let date: String
        let population: Int
    }
}
