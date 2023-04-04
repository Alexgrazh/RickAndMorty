//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 30.03.2023.
//

import Foundation

// MARK: - RMEpisode
struct RMEpisode: Codable {
    let info: InfoEpisode
    let results: [ResultEpisode]
}

// MARK: - Info
struct InfoEpisode: Codable {
    let count, pages: Int
    let next: String
//    let prev: JSONNull?
}

// MARK: - Result
struct ResultEpisode: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
