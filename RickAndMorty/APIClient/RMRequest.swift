//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 01.04.2023.
//

import Foundation

final class RMRequest {
    private struct Conctantc {
       static let baceUrl = "https://rickandmortyapi.com/api"
    }
    
   private let endpoint: RMEndpoint
    
    private let pathComponents: [String]
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString : String {
        var string = Conctantc.baceUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else{return nil}
                
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    public  var url : URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    //MARK: - Public
    
   public init(endpoint: RMEndpoint, queryParameters: [URLQueryItem] = [],pathComponents: [String] = []) {
        self.endpoint = endpoint
        self.queryParameters = queryParameters
        self.pathComponents = pathComponents
    }
}

extension RMRequest{
    static let listCharactersRequests = RMRequest(endpoint: .character
    )
}
