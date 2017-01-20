//
//  BasicAttributedStringESVPassageRenderer.swift
//  CrosswayESVTools
//
//  Created by Tom Duckering on 12/01/2017.
//  Copyright © 2017 Tom Duckering. All rights reserved.
//

import Foundation

import UIKit

import CoreText

public class BasicAttributedStringESVPassageRenderer: ESVPassageAttributedStringRenderer {
    
    public var showVerses: Bool = true
    public var showHeadings: Bool = true
    
    public init() {
        //do nothing
    }
    
    public func attributedString(from passage: ESVPassage) -> NSAttributedString? {
        
        let bodyParaStyle = NSMutableParagraphStyle()
        bodyParaStyle.firstLineHeadIndent = 15.0
        //paraStyle.paragraphSpacingBefore = 10.0
        //bodyParaStyle.lineSpacing = 10
        bodyParaStyle.lineHeightMultiple = 2
    
        let headingParaStyle = NSMutableParagraphStyle()
        headingParaStyle.lineSpacing = 10
        
        
        let bodyFont = UIFont(name: "Helvetica", size: 14)!
        //let fontDescriptor = UIFontDescriptor(
        let superscriptFont = bodyFont.withSize(CGFloat(10))
        let headerFont = UIFont.italicSystemFont(ofSize:14)
        
        let verseNumberAttributes:[String:Any] = [
                                                NSBaselineOffsetAttributeName: 6,
                                                NSFontAttributeName: superscriptFont,
                                                NSParagraphStyleAttributeName: bodyParaStyle
        ]
        
        
        let bodyAttributes:[String:Any] = [NSFontAttributeName:bodyFont, NSParagraphStyleAttributeName: bodyParaStyle]
        let headingAttributes:[String:Any] = [NSFontAttributeName:headerFont, NSParagraphStyleAttributeName: headingParaStyle]
        
        
        let attributedStrings:[NSAttributedString?] = passage.text.map { passageTextElement in
            switch passageTextElement {
            case let .Heading(headingText):
                if showHeadings {
                    let headingAttributedString = NSAttributedString(string: headingText + "\n", attributes: headingAttributes)
                    return headingAttributedString
                } else {
                    return nil
                }
            case let .VerseNumber(verseNumber):
                if showVerses {
                    
                    let verseString = " " + String(verseNumber)
                    
                    let verseNumberAttributedString = NSMutableAttributedString(string: verseString, attributes:verseNumberAttributes)
                    
                    //Set kerning the last char only.
                    verseNumberAttributedString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(verseNumberAttributedString.length - 1, 1))
                    
                    return verseNumberAttributedString
                } else {
                    return NSAttributedString(string:" ",attributes: [:])
                }
            case let .VerseUnit(verseText):
                return NSAttributedString(string: verseText, attributes: bodyAttributes )
            case .EndParagraph:
                return NSAttributedString(string: "\n")
            case .EndLine:
                return NSAttributedString(string: "\n")
            default:
                return nil
            }
        }
        let completeAttributedString = attributedStrings.reduce(NSMutableAttributedString()) { acc,attributedString in
            if let attStr = attributedString {
                acc.append(attStr)
            }
            return acc
        }
        
        return completeAttributedString
    }
}
