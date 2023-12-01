//
//  CityModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 30.11.23.
//

import Foundation

struct ResponseModel: Decodable {
    let results: [CityModel]
}

struct CityModel: Decodable {
    let id: Int
}

