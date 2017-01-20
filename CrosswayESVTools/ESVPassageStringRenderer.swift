//
//  ESVPassageStringRenderer.swift
//  CrosswayESVTools
//
//  Created by Tom Duckering on 12/01/2017.
//  Copyright © 2017 Tom Duckering. All rights reserved.
//

import Foundation

protocol ESVPassageStringArrayRenderer {
    func stringArray(from passage: ESVPassage) -> [String]?
}

protocol ESVPassageStringRenderer {
    func string(from passage: ESVPassage) -> String?
}

protocol ESVPassageAttributedStringRenderer {
    func attributedString(from passage: ESVPassage) -> NSAttributedString?
}
