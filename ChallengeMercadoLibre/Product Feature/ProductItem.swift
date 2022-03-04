//
//  ProductItem.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 27/02/22.
//

import Foundation

public struct ProductItem: Equatable {
    
    public let id:String
    public let title: String
    public let price: Double
    
    public init(id:String , title:String, price: Double) {
        self.id = id
        self.title = title
        self.price = price
    }
}


