//
//  RCSBResponseParser.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

struct PDBDescription {
    var structureId  = ""
    var title = ""
    var atoms = ""
}

class RCSBDescResponseParser : NSObject, NSXMLParserDelegate {
    
    var delegate: RCSBSearch?
    var list : [PDBDescription] = []
    var inPDB = false
    var cdata = ""
    
    func parserDidStartDocument(parser: NSXMLParser) {
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == "PDB" {
            inPDB = true
            
            let desc = PDBDescription(structureId: attributeDict["structureId"] as! String, title: attributeDict["title"] as! String, atoms: attributeDict["nr_atoms"] as! String)
            list.append(desc)
        }
    }

    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
    }

    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "PDB" {
            inPDB = false
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.didCompleteDescResponseParsing(list)
    }
}