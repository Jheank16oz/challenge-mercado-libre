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
    
    func test_seatch_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0, userInfo: [:])
            client.complete(with: clientError)
        })
    }
    
    func test_search_deliversErrorOnNon200HTTPResponse(){
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index,code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_search_deliversErrorOn200HTTPResponseWithInvalidJSON(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data.init("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_search_deliversNoItemsOn200HTTPResponseWithEmptyJSONList(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = Data.init("{\"results\": []}".utf8)
            client.complete(withStatusCode: 200, data:emptyListJSON)
        })
    }
    
    func test_search_deliversItemsOn200HTTPResponseWithJSONItems(){
        let (sut, client) = makeSUT()
        
        let item1 = ProductItem(
            id: UUID(),
            title: "",
            price: 0)
        
        let item1JSON = [
            "id": item1.id.uuidString,
            "title": item1.title,
            "price": item1.price
        ] as [String : Any]
        
        let item2 = ProductItem(
            id: UUID(),
            title: "A title",
            price: 21999)
        
        let item2JSON = [
            "id": item2.id.uuidString,
            "title": item2.title,
            "price": item2.price
        ] as [String : Any]
        
        let resultsJSON = [
            "results": [item1JSON, item2JSON]
        ]
        
        expect(sut, toCompleteWith: .success([item1,item2]), when: {
            let json = try! JSONSerialization.data(withJSONObject: resultsJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut:SearchProduct, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = SearchProduct(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: SearchProduct, query:String = "", toCompleteWith result: SearchProduct.Result, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [SearchProduct.Result]()
        sut.search(query: query) { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy:HTTPClient {
        private var messages = [(url: URL, query:String, completion:(HTTPClientResult) -> Void)]()
        
        var requestedURLs:[URL]{
            return messages.map{ $0.url }
        }
        var requestedQueries:[String]{
            return messages.map{ $0.query }
        }
        
        func get(from url: URL, query: String, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, query, completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code:Int, data:Data = Data(), at index:Int = 0){
            
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data,response))
        }

    }
    
}
