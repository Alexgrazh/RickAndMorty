//
//  RMServise.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 01.04.2023.
//

import Foundation


final class RMServise {
  static  let shared = RMServise()
    
    private init() {}
    
    public func execute<T: Codable>(_ request: RMRequrst,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void){
        
    }
}
