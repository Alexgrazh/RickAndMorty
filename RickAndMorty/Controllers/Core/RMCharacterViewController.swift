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
        
        let request = RMRequrst.init(
            endpoint: .character,
            queryParameters: [URLQueryItem.init(name: "name", value: "rick"),
                              URLQueryItem.init(name: "status", value: "alive")]
        
        )
        print(request.url)
        
        RMServise.shared.execute(request, expecting: RMCharacter.self) { request in
             
           
        }
    }
    
    

}
