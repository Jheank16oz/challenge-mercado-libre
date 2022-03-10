//
//  XCTestCase+MemoryLeakTracking.swift
//  ChallengeMercadoLibreTests
//
//  Created by jpineros on 3/03/22.
//

import Foundation
import XCTest

extension XCTestCase{
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line){
        addTeardownBlock { [ weak instance] in
            XCTAssertNil(instance, "Instance should been deallocated. Potencial memory leak.", file: file, line: line)
        }
    }
}
