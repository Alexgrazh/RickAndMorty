//
//  Extention + UIView.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 10.04.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...){
        views.forEach({
           addSubview($0)
        })
    }
}
