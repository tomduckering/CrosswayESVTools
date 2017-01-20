//
//  ESVAttributedStringRenderTests.swift
//  CrosswayESVTools
//
//  Created by Tom Duckering on 12/01/2017.
//  Copyright © 2017 Tom Duckering. All rights reserved.
//

import Foundation
import XCTest
@testable import CrosswayESVTools

class ESVAttributedStringRenderTests: XCTestCase {
        
    func testCanRenderBasicXMLToAttributedString() {
        let testBundle = Bundle.init(for: ESVAttributedStringRenderTests.self)
        
        let parser = ESVXMLParser(fromBundle: testBundle,withName: "Genesis1")!
        
        let passage = parser.parse()!
        
        let renderer = BasicAttributedStringESVPassageRenderer()
        
        let attributedString = renderer.attributedString(from: passage)
        
        XCTAssertNotNil(attributedString)
    }
}
