//
//  PDBxParser.swift
//  IMVS
//
//  Created by Allistair Crossley on 20/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

/**
* XML parser for PDB elements (within PDBdescription list for instance)
*/
class PDBxParser : NSObject, NSXMLParserDelegate {
    
//    var delegate: RCSBGetDescService?
    
    var molecule = Molecule()
    var helices: [SecondaryStructureRange] = []
    var sheets: [SecondaryStructureRange] = []

    var cdata: String?
    var atom: Atom?
    var inAtomSite = false
    
    /** Start */
    func parserDidStartDocument(parser: NSXMLParser) {
        
    }
    
    /** Element starts */
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == "PDBx:atom_site" {
            inAtomSite = true
            atom = Atom()
            atom!.id = attributeDict["id"] as! String
        } else if
            elementName == "PDBx:Cartn_x" ||
            elementName == "PDBx:Cartn_y" ||
            elementName == "PDBx:Cartn_z" ||
            elementName == "PDBx:auth_atom_id" ||
            elementName == "PDBx:type_symbol" {
            cdata = ""
        }
        
        // label_asym_id
    }
    
    /** Element CDATA */
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        cdata! += string!
    }
    
    /** Element ends */
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "PDBx:atom_site" {
            inAtomSite = false
        } else if inAtomSite && elementName == "PDBx:Cartn_x" {
            atom!.x = (cdata! as NSString).floatValue
        } else if inAtomSite && elementName == "PDBx:Cartn_y" {
            atom!.y = (cdata! as NSString).floatValue
        } else if inAtomSite && elementName == "PDBx:Cartn_z" {
            atom!.z = (cdata! as NSString).floatValue
        } else if inAtomSite && elementName == "PDBx:auth_atom_id" {
            atom!.name = cdata!
        } else if inAtomSite && elementName == "PDBx:type_symbol" {
            atom!.symbol = cdata!
        }
        
        cdata = nil
    }
    
    /** On complete, notify delegate */
    func parserDidEndDocument(parser: NSXMLParser) {

    }
}