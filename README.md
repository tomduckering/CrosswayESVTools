# CrosswayESVTools

This is a Swift framework for parsing the XML that comes back from the esvapi.org endpoint.

Parsing is a bit nasty and not guaranteed to work on the entire Bible (because I've not yet tried the entire Bible). Also there is no proper DTD for the XML returned by the API so it's hard to make such guarantees.

However, it works on a reasonable number of examples so far.

## Parsing

    //Initialise a parser with a string
    let parser = ESVXMLParser(withString: aStringOfXML)
    //parse to a passage.
    let passage = parser.parse()

`passage` is a `struct` of type `ESVPassage` - this struct provides access to:

* `textElements` - an ordered array of `ESVPassageTextElement`s which represent the text.
* `reference` - the passage reference
* `copyright` - the copyright string
* `footnotes` - a dictionary of footnotes

## Basic Rendering

A basic attributed string renderer is available but it's relatively easy to write your own by iterating over the `textElements` array.

To render:

    //Initialise a renderer.
    let renderer = BasicAttributedStringESVPassageRenderer()
    //Set some options
    renderer.showHeadings = false
    //ask the renderer for the attributed string
    let passageAsAttributedString = renderer.attributedString(from: passage)
    
Easy!
