//
//  ESVXMLParseTests.swift
//  CrosswayESVTools
//
//  Created by Tom Duckering on 11/01/2017.
//  Copyright © 2017 Tom Duckering. All rights reserved.
//

import XCTest
@testable import CrosswayESVTools

class ESVXMLParseTests: XCTestCase {
    
    let testBundle = Bundle.init(for: ESVXMLParseTests.self)
    
    func testESVXMLParserCanLoadXMLFromBundle() {
        let parser = ESVXMLParser(fromBundle: testBundle, withName: "Genesis1")!
        XCTAssertNotNil(parser)
    }
    
    func testESVXMLParserCanGenerateESVPassageObject() {
        let parser = ESVXMLParser(fromBundle: testBundle, withName: "Genesis1")!
        
        guard let passage = parser.parse() else {
            XCTFail()
            return
        }
        
        var expectedPassage = ESVPassage()
        expectedPassage.reference = "Genesis 1"
        let versesNumbers = passage.text.filter { textElement in
            switch textElement {
            case .VerseNumber(_):
                return true
            default:
                return false
            }
        }
        
        let verseUnits = passage.text.filter { textElement in
            switch textElement {
            case .VerseUnit(_):
                return true
            default:
                return false
            }
        }
        
        XCTAssertEqual(passage.reference,expectedPassage.reference)
        XCTAssertEqual(versesNumbers.count,31)
        XCTAssertTrue(verseUnits.count >= 31)
    }
    
    func testESVXMLParserCanCopeWithWordsOfChrist() {
        let parser = ESVXMLParser(fromBundle: testBundle, withName: "Matthew3")!
        
        guard let passage = parser.parse() else {
            XCTFail()
            return
        }
        
        let wordsOfChristSections = passage.text.filter { textElement in
            switch textElement {
            case .WordsOfChrist(_):
                return true
            default:
                return false
            }
        }
        
        XCTAssertTrue(wordsOfChristSections.count > 0)
        
    }
    
}
