//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 12.04.2023.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    public let characterName: String
    private let characterStatus: Status
    private let characterImageUrl: URL?
    
  
    
    init(
        characterName: String,
        characterStatus: Status,
        characterImageUrl: URL?
    ){
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return "Status : \(characterStatus.text)"
    }
    
    public func fetchImage(complition: @escaping (Result<Data, Error>)-> Void){
        guard let url = characterImageUrl else {
            complition(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.dowanloadImage(url, complition: complition)
    }
    //MARK: - Hashable
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
