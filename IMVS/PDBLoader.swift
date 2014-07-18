//
//  PDBLoader.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class PDBLoader {
    
    var molecule = Molecule()
    
    func loadMoleculeForPath(pdbFile:String) {
        
        let path = NSBundle.mainBundle().pathForResource(pdbFile, ofType: "pdb")
        molecule.name = pdbFile

        // @TODO if path invalid throw exception
        /*
        let inputStream = NSInputStream.inputStreamWithFileAtPath(path)
        inputStream.delegate = self
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        inputStream.open()
        */
        
        let content = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
        let lines = content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
       
        for line in lines {
            readHEADERWithLine(line)
            readATOMWithLine(line)
        }
        
        molecule.commit()
        
        report()
    }
    
    func getDataForColumnsInLine(line:String, from:Int, to:Int) -> String {
        let tmp = line.substringFromIndex(from - 1)
        return tmp.substringToIndex(to - from + 1).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func isRecordTypeEqualTo(to:String, line:String) -> Bool {
        
        if line.isEmpty || countElements(line) < 6 {
            return false
        }
        
        return getDataForColumnsInLine(line, from: 1, to: 6) == to
    }

    func readHEADERWithLine(line:String) {
        
        if isRecordTypeEqualTo("HEADER", line: line) {
            // molecule.name = getDataForColumnsInLine(line, from: 11, to: 50)
        }
    }
    
    func readATOMWithLine(line:String) {
        
        if isRecordTypeEqualTo("ATOM", line: line) {
            
            let id = getDataForColumnsInLine(line, from: 7, to: 11)
            
            var name = getDataForColumnsInLine(line, from: 13, to: 16)
            var nameJustLetters: String = ""
            
            for char in name {
                
                let test = "\(char)"
                
                // Hacky is numeric test, Swift needs more simple utility functions on String!
                var range: NSRange = NSRangeFromString(test)
                if range.length == 0 && range.location == 0 {
                    nameJustLetters = nameJustLetters.stringByAppendingString(test)
                }
            }
            
            let residue = getDataForColumnsInLine(line, from: 18, to: 20)
            let chain = getDataForColumnsInLine(line, from: 22, to: 22)

            var element = nameJustLetters
            if countElements(line) >= 78 {
                element = getDataForColumnsInLine(line, from: 77, to: 78)
            }
            
            if element.isEmpty {
                element = nameJustLetters
            }

            let x = (getDataForColumnsInLine(line, from: 31, to: 38) as NSString).floatValue
            let y = (getDataForColumnsInLine(line, from: 39, to: 46) as NSString).floatValue
            let z = (getDataForColumnsInLine(line, from: 47, to: 54) as NSString).floatValue
            
            let atom = Atom(id: id, name: name, residue: residue, chain: chain, element: element, x: x, y: y, z: z)
            
            molecule.addAtom(atom)
        }
    }
    
    func report() {

    }
}
