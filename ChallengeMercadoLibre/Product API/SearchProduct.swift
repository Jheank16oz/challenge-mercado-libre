//
//  SearchProduct.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 26/02/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    
    func get(from url: URL, query:String, completion:@escaping (HTTPClientResult) -> Void)
    
}

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
                do {
                    let items = try ProductItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
            
        }
    }
}

private class ProductItemsMapper {
    
    private struct Root:Decodable {
        let results:[Item]
    }

    private struct Item:Decodable {
        
        public let id:UUID
        public let title: String
        public let price: Int
        
        var item:ProductItem{
            return ProductItem(id: id, title: title, price: price)
        }
    }
    static var OK_200: Int { return 200 }
    
    static func map(_ data:Data, _ response: HTTPURLResponse) throws -> [ProductItem]{
        guard response.statusCode == OK_200 else {
            throw SearchProduct.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.results.map { $0.item}
    }
}
