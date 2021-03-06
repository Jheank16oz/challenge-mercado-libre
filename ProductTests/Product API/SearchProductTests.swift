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
    }
    
    func test_search_requestsDataFromURLAndQuery(){
        let (url, query) = makeURL()
        let (sut, client) = makeSUT()
        
        sut.search(query: query){ _ in }
        
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_searchTwice_requestsDataFromURLAndQueryTwice(){
        let (url, query) = makeURL()
        let (sut, client) = makeSUT()
        
        sut.search(query: query){ _ in }
        sut.search(query: query){ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        
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
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
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
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data:emptyListJSON)
        })
    }
    
    func test_search_deliversItemsOn200HTTPResponseWithJSONItems(){
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: "",
            title: "",
            price: 0)
        
        let item2 = makeItem(
            id: "",
            title: "A title",
            price: 21999)
        
        let items = [item1.model,item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_search_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let (url, query) = makeURL()
        var sut: SearchProduct? = SearchProduct(url: url, client: client)
        
        var capturedResults = [SearchProduct.Result]()
        sut?.search(query:query) { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut:SearchProduct, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = SearchProduct(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        
        return (sut, client)
    }
    
    private func makeURL() -> (URL, URLQueryItem){
        var urlComponents = URLComponents(string: "https://a-given-url.com")!
        let query = URLQueryItem(name: "q", value:"any query")
        urlComponents.queryItems = [query]
        return (urlComponents.url ?? URL(string: "")!, query)
    }
    
    private func makeItem(id: String, title: String, price:Double) -> (model:ProductItem, json:[String:Any]) {
        let item = ProductItem(id: id, title: title, price: price)
        
        let json = [
           "id": id,
           "title": title,
           "price": price
       ] as [String : Any]
        
        return (item, json)
    }
    
    func makeItemsJSON(_ items: [[String:Any]]) -> Data {
        let json = ["results": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: SearchProduct, query:URLQueryItem = URLQueryItem(name: "q", value: ""), toCompleteWith result: SearchProduct.Result, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [SearchProduct.Result]()
        sut.search(query: query) { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy:HTTPClient {
        private var messages = [(url: URL, completion:(HTTPClientResult) -> Void)]()
        
        var requestedURLs:[URL]{
            return messages.map{ $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code:Int, data:Data, at index:Int = 0){
            
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
