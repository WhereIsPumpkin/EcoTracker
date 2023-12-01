//
//  SpecieViewModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import Foundation
import NetSwift

typealias DataCompletion<T: Decodable> = (Result<T, Error>) -> Void

protocol SpecieViewModelDelegate: AnyObject {
    func speciesFetched(_ species: [Specie])
    func showError(_ error: Error)
}

final class SpecieViewModel {
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    private var species: [Specie]?
    
    weak var delegate: SpecieViewModelDelegate?
    
    // MARK: - Methods
    private func constructApiUrl(url: String, parameter: String) -> URL? {
        let apiUrlString = url + parameter
        return URL(string: apiUrlString)
    }
    
    private func fetchData<T: Decodable>(url: String, parameter: String, responseType: T.Type, completion: @escaping DataCompletion<T>) {
        guard let apiUrl = constructApiUrl(url: url, parameter: parameter) else {
            completion(.failure(NetworkManager.NetworkError.noData))
            return
        }
        
        networkManager.fetchDecodableData(from: apiUrl, responseType: responseType) { result in
            completion(result)
        }
    }
    
    func fetchCityData(for cityName: String) {
        let url = "https://api.inaturalist.org/v1/places/autocomplete?q="
        fetchData(url: url, parameter: cityName, responseType: ResponseModel.self) { [weak self] result in
            switch result {
            case .success(let data):
                guard let firstResult = data.results.first else {
                    self?.delegate?.showError(NetworkManager.NetworkError.noData)
                    return
                }
                self?.fetchSpeciesData(for: String(firstResult.id))
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func fetchSpeciesData(for cityId: String) {
        let url = "https://api.inaturalist.org/v1/observations/species_counts?place_id="
        fetchData(url: url, parameter: cityId, responseType: SpeciesResult.self) { [weak self] result in
            switch result {
            case .success(let speciesData):
                self?.species = speciesData.results
                self?.delegate?.speciesFetched(speciesData.results)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}
