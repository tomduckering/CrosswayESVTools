//
//  ESVPassage.swift
//  CrosswayESVTools
//
//  Created by Tom Duckering on 12/01/2017.
//  Copyright © 2017 Tom Duckering. All rights reserved.
//

import Foundation

enum ESVPassageTextElement {
    case BeginChapter(Int)
    case EndChapter
    case Heading(String)
    case VerseNumber(Int)
    case VerseUnit(String)
    case WordsOfChrist(String)
    case BeginParagraph
    case EndParagraph
    case FootNoteMarker(String)
    case FootNote(String,String)
    case Italic(String)
    case BeginBlockIndent
    case EndBlockIndent
    case BeginLine(indented: Bool)
    case EndLine
}

public struct ESVPassage {
    var reference:String?
    var copyright:String?
    var text:[ESVPassageTextElement] = []
    var footnotes:[String:[String]] = [String:[String]]()
    
    mutating func addFootNote(forID id: String,withBody body:String) {
        guard var footnotesForID = footnotes[id]
            else {
                footnotes[id] = [String]()
                footnotes[id]?.append(body)
                return
        }
        footnotesForID.append(body)
    }
}
