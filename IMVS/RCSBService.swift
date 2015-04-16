//
//  RCSBSearch.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

class RCSBService {
    
    var delegate: RCSBServiceDelegate?
    
    func search(query: String) {

        let url = NSURL(string: "http://www.rcsb.org/pdb/rest/search")
        
        let requestXML = "<orgPdbQuery>" +
            "<queryType>org.pdb.query.simple.AdvancedKeywordQuery</queryType>" +
            "<keywords>\(query)</keywords>" +
            "</orgPdbQuery>"
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = requestXML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            if data == nil {
                println("dataTaskWithRequest error: \(error)")
                return
            }
            
            // println(response)
            
            let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
            let ids = str.componentsSeparatedByString("\n") as NSArray
            let idCSV = ids.componentsJoinedByString(",")
            self.getDescriptionsForIds(idCSV)
        }
        
        task.resume()
    }
    
    private func getDescriptionsForIds(ids: String) {
        
        let url = NSURL(string: "http://www.rcsb.org/pdb/rest/describePDB?structureId=\(ids)")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            if data == nil {
                println("dataTaskWithRequest error: \(error)")
                return
            }
            
            // println(response)
            
            // let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
            // println(str)
            
            let descResponseParser = RCSBDescResponseParser()
            descResponseParser.delegate = self

            let parser = NSXMLParser(data: data)
            parser.delegate = descResponseParser
            parser.parse()
            
            // you can now check the value of the `success` variable here
        }
        
        task.resume()
    }
    
    func didCompleteDescResponseParsing(list: [PDBDescription]) {
        println("didCompleteDescResponseParsing list: \(list.count)")
        delegate?.setList(list)
    }
    
    func downloadFile(pdbDesc: PDBDescription) {

        let url = NSURL(string: "http://www.rcsb.org/pdb/download/downloadFile.do?fileFormat=pdb&compression=NO&structureId=\(pdbDesc.structureId)")
        
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url!) {
            (url, response, error) in
            
            if url == nil {
                println("downloadTaskWithURL error: \(error)")
                return
            }
            
            // Write the file
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            let pdbPath = documentsPath.stringByAppendingPathComponent("\(pdbDesc.structureId).pdb")
            NSData(contentsOfURL: url)?.writeToFile(pdbPath, atomically: true)
            
            // Notify delegate of file availability
            self.delegate?.didDownloadFile(pdbDesc, path: pdbPath)
        }
        
        task.resume()
    }
}