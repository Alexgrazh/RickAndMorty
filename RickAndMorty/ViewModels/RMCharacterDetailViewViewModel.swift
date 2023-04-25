//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 25.04.2023.
//

import Foundation

class RMCharacterDetailViewViewModel {
    private let character: ResultCharacter
    
    init(character: ResultCharacter){
        self.character = character
    }
    
    public var title: String{
        character.name.uppercased()
    }
}
