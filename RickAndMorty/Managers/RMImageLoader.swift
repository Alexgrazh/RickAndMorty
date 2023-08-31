//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 11.05.2023.
//

import Foundation

final class RMImageLoader {
    static var shared = RMImageLoader()
    
    private var imageDataCach = NSCache<NSString, NSData>()
    
    private init(){}
    
    public func dowanloadImage(_ url: URL, complition: @escaping (Result<Data, Error>)-> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCach.object(forKey: key) {
            complition(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil  else{
                complition(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCach.setObject(value, forKey: key)
            complition(.success(data))
        }
        task.resume()
    }
    
}
