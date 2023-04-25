//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 25.04.2023.
//

import UIKit

final class RMCharacterDetailViewController: UIViewController {
    
    private let viewModal : RMCharacterDetailViewViewModel
    
    init(viewModal: RMCharacterDetailViewViewModel){
        self.viewModal = viewModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsuppurted")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = viewModal.title
    }
   

}
