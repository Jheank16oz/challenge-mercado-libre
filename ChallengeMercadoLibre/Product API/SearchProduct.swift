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
    
    public func search(query:URLQueryItem, completion: @escaping (Result) -> Void) {
        let urlWithQueries = url.appending(query)
        client.get(from: urlWithQueries) { [weak self] result in
            guard self != nil else {
                return
            }
            
            switch result {
            case let .success(data, response):
                completion(ProductItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
            
        }
    }
    
    
}

private extension URL {

    func appending(_ queryItem: URLQueryItem) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        queryItems.append(queryItem)

        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
