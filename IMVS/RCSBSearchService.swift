//
//  RCSBSearch.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

/**
 * Search for PDBs.
 */
class RCSBSearchService {
   
    /** Callback delegate for post async network events */
    var delegate: RCSBSearchServiceDelegate?
    
    /** Search by query */
    func search(query: String) {

        let url = NSURL(string: "http://www.rcsb.org/pdb/rest/search")
        
        // Free-text search
        // TODO: escape
        let requestXML =
            "<orgPdbQuery>" +
                "<queryType>org.pdb.query.simple.AdvancedKeywordQuery</queryType>" +
                "<keywords>\(query)</keywords>" +
            "</orgPdbQuery>"
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = requestXML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        println(requestXML)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            // TODO: callback to delegate with error
            if data == nil {
                println("dataTaskWithRequest error: \(error)")
                return
            }
            
            let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
            
            var list: [MoleculeSummary] = []
            
            let ids = str.componentsSeparatedByString("\n") as NSArray
            for id in ids {
                list.append(MoleculeSummary(id: id as! String, title: nil, atoms: nil))
            }
            
            self.delegate?.setMoleculeList(list)
        }
        
        task.resume()
    }
}