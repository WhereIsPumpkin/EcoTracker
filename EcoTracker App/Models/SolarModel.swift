//
//  SolarModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 01.12.23.
//

import Foundation

struct SolarData: Decodable {
    let outputs: SolarOutputs

    struct SolarOutputs: Decodable {
        let avgDni: SolarValues
        let avgGhi: SolarValues
        let avgLatTilt: SolarValues

        enum CodingKeys: String, CodingKey {
            case avgDni = "avg_dni"
            case avgGhi = "avg_ghi"
            case avgLatTilt = "avg_lat_tilt"
        }
    }

    struct SolarValues: Decodable {
        let annual: Double
        let monthly: [String: Double]
    }
}
