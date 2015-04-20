//
//  RCSBDownloadService.swift
//  IMVS
//
//  Created by Allistair Crossley on 20/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//


import Foundation

/**
* Download a PDB file.
*/
class RCSBDownloadService {
    
    /** Callback delegate for post async network events */
    var delegate: RCSBDownloadServiceDelegate?
    
    /** Download the PDB file */
    func downloadFile(molSumm: MoleculeSummary) {
        
        let url = NSURL(string: "http://www.rcsb.org/pdb/download/downloadFile.do?fileFormat=pdb&compression=NO&structureId=\(molSumm.id)")
        
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url!) {
            (url, response, error) in
            
            // TODO: callback to delegate with error
            if url == nil {
                println("downloadTaskWithURL error: \(error)")
                return
            }
            
            // Write the file
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            let pdbPath = documentsPath.stringByAppendingPathComponent("\(molSumm.id).xml")
            NSData(contentsOfURL: url)?.writeToFile(pdbPath, atomically: true)
            molSumm.path = pdbPath
            
            // Notify delegate of file availability and location
            self.delegate?.didDownloadMoleculeFile(molSumm)
        }
        
        task.resume()
    }
}
