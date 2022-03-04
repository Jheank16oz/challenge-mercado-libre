//
//  ProductItemsMapper.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 2/03/22.
//

import Foundation

internal final class ProductItemsMapper {
    
    private struct Root:Decodable {
        let results:[Item]
        
        var products:[ProductItem] {
            return results.map { $0.item}
        }
    }

    private struct Item:Decodable {
        
        public let id:String
        public let title: String
        public let price: Double
        
        var item:ProductItem{
            return ProductItem(id: id, title: title, price: price)
        }
    }
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data:Data, from response: HTTPURLResponse) -> SearchProduct.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(root.products)
        
    }
}
