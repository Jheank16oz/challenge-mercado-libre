//
//  SearchProductTests.swift
//  ChallengeMercadoLibreTests
//
//  Created by jpineros on 26/02/22.
//

import Foundation
import XCTest
import ChallengeMercadoLibre

class SearchProductTests:XCTestCase {
    
    func test_init_doesNotRequestDataFromURLAndQuery(){
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.requestedQuery)
    }
    
    func test_search_requestsDataFromURLAndQuery(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let (sut, client) = makeSUT(url: url)
        
        sut.search(query: query)
        
        XCTAssertEqual(client.requestedURL, url)
        XCTAssertEqual(client.requestedQuery, query)
    }
    
    func test_searchTwice_requestsDataFromURLAndQueryTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let (sut, client) = makeSUT(url: url)
        
        sut.search(query: query)
        sut.search(query: query)
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.requestedQueries, [query, query])
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
        var requestedURLs = [URL]()
        var requestedQueries = [String]()
        
        func get(from url: URL, query: String) {
            requestedURL = url
            requestedQuery = query
            requestedURLs.append(url)
            requestedQueries .append(query)
            
        }

    }
    
}
