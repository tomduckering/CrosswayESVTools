//
//  ESVXMLParser.swift
//  CrosswayESVTools
//
//  Created by Tom Duckering on 11/01/2017.
//  Copyright © 2017 Tom Duckering. All rights reserved.
//

import Foundation

let NEWLINE = "\n"
let XML_FILE_TYPE = "xml"

enum ESVXMLElement:String {
    case BeginChapter     = "begin-chapter"
    case EndChapter       = "end-chapter"
    case Reference        = "reference"
    case Heading          = "heading"
    case VerseNumber      = "verse-num"
    case VerseUnit        = "verse-unit"
    case BeginParagraph   = "begin-paragraph"
    case EndParagraph     = "end-paragraph"
    case FootNote         = "footnote"
    case WordsOfChrist    = "woc"
    case Italic           = "i"
    case BeginBlockIndent = "begin-block-indent"
    case EndBlockIndent   = "end-block-indent"
    case BeginLine        = "begin-line"
    case EndLine          = "end-line"
    case CopyRight        = "copyright"
}

extension String {
    func fixUnknownEntities() -> String {
        let replacementMapping:[String:String] = ["&ldblquot;" :"\u{201C}",
                                                  "&rdblquot;" :"\u{201D}",
                                                  "&lquot;"    :"\u{2018}",
                                                  "&rquot;"    :"\u{2019}",
                                                  "&emdash;"   :"\u{2014}",
                                                  "&endash;"   :"\u{2013}",
                                                  "&ellipsis;" :"\u{2026}",
                                                  "&ellipsis4;":"\u{2026}.", //This one is nasty!
                                                  "&emacron;"  :"ē"]
        
        return replacementMapping.reduce(self) { acc,tuple in
            return acc.replacingOccurrences(of: tuple.key, with: tuple.value)
        }
    }
}



public class ESVXMLParser: NSObject, XMLParserDelegate {
    
    let parser:XMLParser
    var elementStack: [ESVXMLElement] = []
    var passage:ESVPassage = ESVPassage()
    var currentFootnoteID = ""
    
    public init(withString xmlString: String) {
        
        let hackedXMLString = xmlString.fixUnknownEntities()
        
        let xmlData = hackedXMLString.data(using: String.Encoding.utf8)!
        parser = XMLParser(data: xmlData)
        
        super.init()
        parser.delegate = self;
    }
    
    public init?(fromBundle bundle: Bundle = Bundle.main, withName name: String) {
        do {
            guard let xmlFile = bundle.path(forResource: name, ofType: XML_FILE_TYPE)
                else {
                    return nil
            }
            
            let xmlString = try String(contentsOfFile: xmlFile)
            
            let hackedXMLString = xmlString.fixUnknownEntities()
            
            let xmlData = hackedXMLString.data(using: String.Encoding.utf8)!
            parser = XMLParser(data: xmlData)
            
            super.init()
            parser.delegate = self;
            
        } catch {
            return nil
        }
    }
    
    public func parse() -> ESVPassage? {
        let success = parser.parse()
        if success {
            return passage
        } else {
            return nil
        }
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        guard let element = ESVXMLElement(rawValue: elementName)
            else {
                return
        }
        
        switch element {
        case .BeginChapter:
            guard let chapterNumber = Int(attributeDict["num"]!)
                else {
                    parser.abortParsing()
                    break
            }
            
            passage.text.append(.BeginChapter(chapterNumber))
            
        case .FootNote:
            guard let footNoteID = attributeDict["id"]
                else {
                    parser.abortParsing()
                    break
            }
            
            passage.text.append(.FootNoteMarker(footNoteID))
            currentFootnoteID = footNoteID
            
        case .BeginBlockIndent:
            passage.text.append(.BeginBlockIndent)
            
        case .BeginParagraph:
            passage.text.append(.BeginParagraph)
            
        case .BeginLine:
            if let classs = attributeDict["class"] {
                let isIndented = classs == "indent"
                passage.text.append(.BeginLine(indented: isIndented))
            } else {
                passage.text.append(.BeginLine(indented: false))
            }
            
        case .EndBlockIndent:
            passage.text.append(.EndBlockIndent)
            
        case .EndParagraph:
            passage.text.append(.EndParagraph)
            
        case .EndLine:
            passage.text.append(.EndLine)
            
        default:
            break
        }
        
        elementStack.append(element)
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementStack.last == ESVXMLElement(rawValue: elementName) {
            if let element = elementStack.popLast() {
                switch element {
                case .FootNote:
                    currentFootnoteID = ""
                default:
                    break
                }
            }
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if string == NEWLINE {
            return
        }
        
        if let topElement = elementStack.last {
            switch topElement {
            case .Reference:
                passage.reference = string
            case .Heading:
                passage.text.append(ESVPassageTextElement.Heading(string))
            case .VerseNumber:
                guard let verseNumber = Int(string)
                else {
                    parser.abortParsing()
                    break
                }
                passage.text.append(ESVPassageTextElement.VerseNumber(verseNumber))
                
            case .VerseUnit:
                passage.text.append(ESVPassageTextElement.VerseUnit(string))
                
            case .CopyRight:
                passage.copyright = string
                
            case .FootNote:
                passage.addFootNote(forID: currentFootnoteID, withBody: string)
            case .WordsOfChrist:
                passage.text.append(ESVPassageTextElement.WordsOfChrist(string))
                
            default:
                break
            }
        }
    }
}
