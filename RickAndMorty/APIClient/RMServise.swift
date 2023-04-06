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
    
    enum rmServisesError : Error {
        case failedCreateToRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(_ request: RMRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void){
        guard let urlRequest = self.rmRequest(from: request) else {
            completion(.failure(rmServisesError.failedCreateToRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(error ?? rmServisesError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
                
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: -  Private
    
    private func rmRequest(from rmRequest: RMRequest) -> URLRequest? {
        
        guard let url = rmRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
