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



class SearchProductTests:XCTestCase {
    
    func test_init_doesNotRequestDataFromURLAndQuery(){
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.requestedQuery)
    }
    
    func test_search_requestDataFromURLAndQuery(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let (sut, client) = makeSUT(url: url)
        
        sut.search(query: query)
        
        XCTAssertEqual(client.requestedURL, url)
        XCTAssertEqual(client.requestedQuery, query)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut:SearchProduct, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = SearchProduct(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy:HTTPClient {
        var requestedURL: URL?
        var requestedQuery:String?
        
        func get(from url: URL, query: String) {
            requestedURL = url
            requestedQuery = query
        }

    }
    
}
