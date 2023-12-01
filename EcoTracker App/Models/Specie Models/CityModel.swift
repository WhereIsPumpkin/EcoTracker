//
//  CityModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 30.11.23.
//

import Foundation

struct ResponseModel: Codable {
    let results: [CityModel]
}

struct CityModel: Codable {
    let id: Int
}

