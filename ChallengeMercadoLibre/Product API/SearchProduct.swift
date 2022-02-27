//
//  SearchProduct.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 26/02/22.
//

import Foundation

public protocol HTTPClient {
    
    func get(from url: URL, query:String, completion:@escaping (Error) -> Void)
    
}

public final class SearchProduct{
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
    }
    
    public init(url:URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    public func search(query:String, completion: @escaping (Error) -> Void) {
        client.get(from: url, query:query) { error in
            completion(.connectivity)
        }
    }
}
