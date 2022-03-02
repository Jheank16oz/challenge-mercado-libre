//
//  SearchProduct.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 26/02/22.
//

import Foundation

public final class SearchProduct{
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([ProductItem])
        case failure(Error)
    }
    
    public init(url:URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    public func search(query:String, completion: @escaping (Result) -> Void) {
        client.get(from: url, query:query) { result in
            switch result {
            case let .success(data, response):
                completion(ProductItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
            
        }
    }
}
