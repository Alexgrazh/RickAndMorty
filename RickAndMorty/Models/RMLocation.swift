//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 30.03.2023.
//

import Foundation

// MARK: - RMLocation
struct RMLocation: Codable {
    let info: InfoLocation
    let results: [ResultLocation]
}

// MARK: - Info
struct InfoLocation: Codable {
    let count, pages: Int
    let next: String
//    let prev: JSONNull?
}

// MARK: - Result
struct ResultLocation: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
