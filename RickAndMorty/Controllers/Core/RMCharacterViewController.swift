//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 30.03.2023.
//

import UIKit

final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        RMServise.shared.execute(.listCharactersRequests,
                                 expecting: RMCharacter.self) { result in
            
            switch result {
            case .success(let model):
                print(String(describing: model))
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
    
    

}
