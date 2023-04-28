//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 26.04.2023.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
        static let identefire = "RMFooterLoadingCollectionReusableView"
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addContraint(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func startAnimeting(){
        spinner.startAnimating()
    }
}
