//
//  RCSBResponseParser.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

/**
 * XML parser for PDB elements (within PDBdescription list for instance)
 */
class RCSBGetDescResponseParser : NSObject, NSXMLParserDelegate {
    
    var delegate: RCSBGetDescService?
    
    var list: [MoleculeSummary] = []
    var inPDB = false
    
    /** Start */
    func parserDidStartDocument(parser: NSXMLParser) {

    }
    
    /** 
     * Look for PDB element starts - create summary per element from attributes 
     * and add to list
     */
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == "PDB" {
            inPDB = true
            
            var molSumm = MoleculeSummary(id: attributeDict["structureId"] as! String, title: attributeDict["title"] as? String, atoms: attributeDict["nr_atoms"] as! String)
            list.append(molSumm)
        }
    }

    /** Look for CDATA, not used */
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
    }

    /** Look for PDB element ends, not used */
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "PDB" {
            inPDB = false
        }
    }
    
    /** On complete, notify delegate */
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.didCompleteDescResponseParsing(list)
    }
}