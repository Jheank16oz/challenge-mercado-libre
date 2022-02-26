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
    let url: URL
    
    init(url:URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    func search(query:String) {
        client.get(from: url, query:query)
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
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        _ = SearchProduct(url:url, client: client)
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.requestedQuery)
    }
    
    func test_search_requestDataFromURLAndQuery(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let client = HTTPClientSpy()
        let sut = SearchProduct(url: url, client: client)
        
        sut.search(query: query)
        
        XCTAssertEqual(client.requestedURL, url)
        XCTAssertEqual(client.requestedQuery, query)
    }
    
    
}
