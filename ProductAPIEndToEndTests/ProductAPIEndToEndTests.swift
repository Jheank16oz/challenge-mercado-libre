//
//  ProductAPIEndToEndTests.swift
//  ProductAPIEndToEndTests
//
//  Created by jpineros on 4/03/22.
//

import Foundation
import XCTest
import ChallengeMercadoLibre

class ProductAPIEndToEndTests:XCTestCase {
    
    func test_endToEndTestServerGETSearchResult_matchesFixedTestAccountData() {
        let testServerURL = URL(string: "https://api.mercadolibre.com/sites/MLA/search")!
        let client = URLSessionHTTPClient()
        let search = SearchProduct(url: testServerURL, client: client)
        
        let exp = expectation(description: "Wait for search completion")
        
        var receivedResult:SearchProduct.Result?
        search.search(query: URLQueryItem(name: "q", value: "Motorola%20G6")) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(items)?:
            XCTAssertEqual(items.count, 8, "Expected 8 items in the test account feed")
            
        case let .failure(error)?:
            XCTFail("Expected succesful product result, got \(error) instead")
            
        default:
            XCTFail("Expected successful product result, got not not result instead")
        }
        
    }
}
