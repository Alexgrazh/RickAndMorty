//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 30.03.2023.
//

import UIKit

final class RMCharacterViewController: UIViewController, CharacterListViewDelegate {

    private let characterListView = CharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        view.addSubview(characterListView)
       setUoView()
        
    }
    
    private func setUoView(){
        characterListView.delegate = self
        NSLayoutConstraint.activate([

            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func rmCharacterLictView(_ characterLictView: CharacterListView, didSelectCharacter character: ResultCharacter) {
        let viewModal = RMCharacterDetailViewViewModel(character: character)
        let detaleVC = RMCharacterDetailViewController(viewModal: viewModal)
        detaleVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detaleVC, animated: true)
    }
}
