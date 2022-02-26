//
//  SearchProduct.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 26/02/22.
//

import Foundation

public protocol HTTPClient {
    
    func get(from url: URL, query:String)
    
}

public final class SearchProduct{
    private let url: URL
    private let client: HTTPClient
    
    public init(url:URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    public func search(query:String) {
        client.get(from: url, query:query)
    }
}
