//
//  PopulationViewModel.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import Foundation
import NetSwift

protocol PopulationViewModelDelegate: AnyObject {
    func didFetchTotalPopulation(_ totalPopulation: [String: [TotalPopulation.Population]])
    func didFailWithError(_ error: Error)
}

final class PopulationViewModel {
    private let networkManager: NetworkManager
    weak var delegate: PopulationViewModelDelegate?
    
    var totalPopulation: [String: [TotalPopulation.Population]]?
    var error: Error?
    
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func viewDidload(){
        fetchCountries()
    }
    
    // MARK: - Public Methods
    
    func fetchCountries() {
        let urlString = "https://d6wn6bmjj722w.population.io/1.0/countries/"
        guard let url = URL(string: urlString) else { return }
        
        networkManager.fetchDecodableData(from: url, responseType: CountryList.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.fetchPopulationData(for: data.countries)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func fetchPopulationData(for countries: [String]) {
        var totalPopulation = [String: [TotalPopulation.Population]]()
        
        let dispatchGroup = DispatchGroup()
        
        for country in countries {
            dispatchGroup.enter()
            
            let urlString = "https://d6wn6bmjj722w.population.io:443/1.0/population/\(country)/today-and-tomorrow/"
            guard let url = URL(string: urlString) else { continue }
            
            networkManager.fetchDecodableData(from: url, responseType: TotalPopulation.self) { result in
                switch result {
                case .success(let data):
                    //     print("\(country): \(data)")
                    totalPopulation[country] = data.totalPopulation
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.delegate?.didFailWithError(error)
                    }
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if totalPopulation.isEmpty {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid country name"])
                self.delegate?.didFailWithError(error)
            } else {
                self.delegate?.didFetchTotalPopulation(totalPopulation)
            }
        }
    }
}


