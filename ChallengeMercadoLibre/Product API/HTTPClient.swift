//
//  HTTPClient.swift
//  ChallengeMercadoLibre
//
//  Created by jpineros on 2/03/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    
    func get(from url: URL, query:String, completion:@escaping (HTTPClientResult) -> Void)
    
}
