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
    
}

class HTTPClient {
    var requestedURL: URL?
    var query:String?
}

class SearchProductTests:XCTestCase {
    
    func test_init_doesNotRequestDataFromURLAndQuery(){
        let client = HTTPClient()
        _ = SearchProduct()
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.query)
    }
    
    
}
