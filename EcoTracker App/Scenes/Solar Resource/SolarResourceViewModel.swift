//
//  SolarResourceViewModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import Foundation
import NetSwift

final class SolarResourceViewModel {
    private let networkManager = NetworkManager.shared

    func fetchSolarData(latitude: Double, longitude: Double, completion: @escaping (Result<SolarData, Error>) -> Void) {
        let urlString = "https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=f4HhkhZreK8nqtCdlYtbgcQkjispQwQiw5jd87BT&lat=\(latitude)&lon=\(longitude)"
        
        if let url = URL(string: urlString) {
            networkManager.fetchDecodableData(from: url, responseType: SolarData.self) { result in
                completion(result)
            }
        }
    }
    
}

 

