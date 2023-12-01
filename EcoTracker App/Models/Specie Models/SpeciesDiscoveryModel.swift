//
//  SpeciesDiscovery.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 01.12.23.
//

import Foundation

import Foundation

struct SpeciesResult: Decodable {
    let results: [Specie]

    private enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Specie: Decodable {
    let taxon: Taxon

    struct Taxon: Decodable {
        let name: String
        let defaultPhoto: DefaultPhoto?
        let wikipediaURL: String?

        private enum CodingKeys: String, CodingKey {
            case name
            case defaultPhoto = "default_photo"
            case wikipediaURL = "wikipedia_url"
        }
    }

    struct DefaultPhoto: Decodable {
        let url: String
        let attribution: String
    }
}
