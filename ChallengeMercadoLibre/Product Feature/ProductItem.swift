//
//  ProductItem.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 27/02/22.
//

import Foundation

public struct ProductItem: Equatable {
    
    public let id:UUID
    public let title: String
    public let price: Int
    
    public init(id:UUID , title:String, price: Int) {
        self.id = id
        self.title = title
        self.price = price
    }
}

extension ProductItem:Decodable{
    
}
