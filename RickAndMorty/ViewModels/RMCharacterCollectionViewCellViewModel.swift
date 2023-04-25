//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 12.04.2023.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {
    
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
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil  else{
                complition(.failure(error ?? URLError(.badServerResponse)))
                return
            }
                           complition(.success(data))
        }
        task.resume()
    }
}
