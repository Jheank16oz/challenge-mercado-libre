//
//  SearchProductTests.swift
//  ChallengeMercadoLibreTests
//
//  Created by jpineros on 26/02/22.
//

import Foundation
import XCTest
@testable import ChallengeMercadoLibre

class SearchProduct{
    let client: HTTPClient
    
    init(client: HTTPClient){
        self.client = client
    }
    
    func search() {
        client.get(from: URL(string: "https://a-url.com")!, query:"any query")
    }
}

protocol HTTPClient {
    
    func get(from url: URL, query:String)
    
}

class HTTPClientSpy:HTTPClient {
    
    func get(from url: URL, query: String) {
        requestedURL = url
        requestedQuery = query
    }
    
    var requestedURL: URL?
    var requestedQuery:String?
}

class SearchProductTests:XCTestCase {
    
    func test_init_doesNotRequestDataFromURLAndQuery(){
        let client = HTTPClientSpy()
        _ = SearchProduct(client: client)
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.requestedQuery)
    }
    
    func test_search_requestDataFromURLAndQuery(){
        let client = HTTPClientSpy()
        let sut = SearchProduct(client: client)
        
        sut.search()
        
        XCTAssertNotNil(client.requestedURL)
        XCTAssertNotNil(client.requestedQuery)
    }
    
    
}
