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
        
        sut.search(query: query){ _ in }
        
        XCTAssertEqual(client.requestedURLs,[url])
        XCTAssertEqual(client.requestedQueries, [query])
    }
    
    func test_searchTwice_requestsDataFromURLAndQueryTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let query = "any query"
        let (sut, client) = makeSUT(url: url)
        
        sut.search(query: query){ _ in }
        sut.search(query: query){ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.requestedQueries, [query, query])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        var capturedErrors = [SearchProduct.Error]()
        sut.search(query: "") { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0, userInfo: [:])
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNonHTTPResponse(){
        let (sut, client) = makeSUT()
        
        var capturedErrors = [SearchProduct.Error]()
        sut.search(query: "") { capturedErrors.append($0) }
        
        client.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut:SearchProduct, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = SearchProduct(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy:HTTPClient {
        private var messages = [(url: URL, query:String, completion:(Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs:[URL]{
            return messages.map{ $0.url }
        }
        var requestedQueries:[String]{
            return messages.map{ $0.query }
        }
        
        func get(from url: URL, query: String, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, query, completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code:Int, at index:Int = 0){
            
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )
            
            messages[index].completion(nil, response)
        }

    }
    
}
