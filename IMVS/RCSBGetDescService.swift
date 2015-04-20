//
//  RCSBGetDescService.swift
//  IMVS
//
//  Created by Allistair Crossley on 20/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

/**
* Get the description of a molecule.
*/
class RCSBGetDescService {
    
    /** Callback delegate for post async network events */
    var delegate: RCSBGetDescServiceDelegate?
    
    /** Obtain full description of a PDB ID */
    func loadMolecule(molSumm: MoleculeSummary) {
        
        let url = NSURL(string: "http://www.rcsb.org/pdb/rest/describePDB?structureId=\(molSumm.id)")
        println(url)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            // TODO: callback to delegate with error
            if data == nil {
                println("dataTaskWithRequest error: \(error)")
                return
            }
            
            // Response is XML, parse it
            let descResponseParser = RCSBGetDescResponseParser()
            descResponseParser.delegate = self
            let parser = NSXMLParser(data: data)
            parser.delegate = descResponseParser
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: From RCSBDescResponseParser
    
    func didCompleteDescResponseParsing(list: [MoleculeSummary]) {
        println("didCompleteDescResponseParsing list: \(list.count)")
        delegate?.setMolecule(list[0])
    }
}