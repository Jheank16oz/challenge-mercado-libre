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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        XCTAssertTrue(client.requestedQueries.isEmpty)
    }
    
    func test_search_requestsDataFromURLAndQuery(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let (sut, client) = makeSUT(url: url)
        
        sut.search(query: query)
        
        XCTAssertEqual(client.requestedURLs,[url])
        XCTAssertEqual(client.requestedQueries, [query])
    }
    
    func test_searchTwice_requestsDataFromURLAndQueryTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let (sut, client) = makeSUT(url: url)
        
        sut.search(query: query)
        sut.search(query: query)
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.requestedQueries, [query, query])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        var capturedErrors = [SearchProduct.Error]()
        sut.search(query: "") { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0, userInfo: [:])
        client.completions[0](clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut:SearchProduct, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = SearchProduct(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy:HTTPClient {
        var requestedURLs = [URL]()
        var requestedQueries = [String]()
        var error: Error?
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, query: String, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
            requestedQueries .append(query)
        }

    }
    
}
