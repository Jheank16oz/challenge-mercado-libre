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
    }

    private struct Item:Decodable {
        
        public let id:UUID
        public let title: String
        public let price: Int
        
        var item:ProductItem{
            return ProductItem(id: id, title: title, price: price)
        }
    }
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data:Data, _ response: HTTPURLResponse) throws -> [ProductItem]{
        guard response.statusCode == OK_200 else {
            throw SearchProduct.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.results.map { $0.item}
    }
}
